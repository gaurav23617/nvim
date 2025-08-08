return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure custom linters using Mason-managed tools
    local mason_bin_dir = vim.fn.stdpath("data") .. "/mason/bin"

    -- Customize golangcilint to ignore exit codes (golangci-lint exits with code 1-3 when issues are found)
    local golangcilint = require("lint").linters.golangcilint
    golangcilint.ignore_exitcode = true

    -- Configure Laravel Pint for linting (using --test mode)
    local pint_cmd = vim.fn.executable(mason_bin_dir .. "/pint") == 1 and mason_bin_dir .. "/pint"
      or "pint"

    lint.linters.pint = {
      cmd = pint_cmd,
      stdin = false,
      args = { "--test" },
      stream = "stderr", -- Pint outputs diagnostics to stderr
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}

        if not output or output == "" then
          return diagnostics
        end

        -- Check if output contains style issues
        -- Pint outputs human-readable format by default when there are issues
        if string.find(output, "FAIL") or string.find(output, "differs") then
          table.insert(diagnostics, {
            lnum = 0,
            col = 0,
            message = "Code style issues found - run formatter to fix",
            severity = vim.diagnostic.severity.WARN,
            source = "pint",
          })
        end

        return diagnostics
      end,
    }

    -- Custom Biome linter configuration
    local biome_cmd = vim.fn.executable(mason_bin_dir .. "/biome") == 1
        and mason_bin_dir .. "/biome"
      or "biome"

    lint.linters.biome = {
      cmd = biome_cmd,
      stdin = true,
      args = {
        "lint",
        "--stdin-file-path",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
        "--diagnostic-level=info",
        "--reporter=json",
      },
      stream = "stdout",
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}

        if not output or output == "" then
          return diagnostics
        end

        -- Parse JSON output from biome
        local ok, json = pcall(vim.json.decode, output)
        if not ok then
          -- If JSON parsing fails, try to extract any useful info from plain text
          if string.find(output, "error") or string.find(output, "Error") then
            table.insert(diagnostics, {
              lnum = 0,
              col = 0,
              message = "Biome error: " .. output:sub(1, 100),
              severity = vim.diagnostic.severity.ERROR,
              source = "biome",
            })
          end
          return diagnostics
        end

        -- Process biome JSON output
        if json.diagnostics then
          for _, diagnostic in ipairs(json.diagnostics) do
            local severity = vim.diagnostic.severity.INFO

            if diagnostic.severity == "error" then
              severity = vim.diagnostic.severity.ERROR
            elseif diagnostic.severity == "warning" then
              severity = vim.diagnostic.severity.WARN
            end

            -- Extract location info
            local lnum = 0
            local col = 0
            local end_lnum = 0
            local end_col = 0

            if diagnostic.location and diagnostic.location.span then
              lnum = (diagnostic.location.span.start and diagnostic.location.span.start.line or 1)
                - 1
              col = (diagnostic.location.span.start and diagnostic.location.span.start.column or 1)
                - 1
              end_lnum = (
                diagnostic.location.span["end"] and diagnostic.location.span["end"].line
                or lnum + 1
              ) - 1
              end_col = (
                diagnostic.location.span["end"] and diagnostic.location.span["end"].column
                or col + 1
              ) - 1
            end

            table.insert(diagnostics, {
              lnum = lnum,
              col = col,
              end_lnum = end_lnum,
              end_col = end_col,
              message = diagnostic.description or diagnostic.message or "Biome diagnostic",
              code = diagnostic.category,
              severity = severity,
              source = "biome",
            })
          end
        end

        return diagnostics
      end,
    }

    -- Configure linters by filetype (using Mason-managed tools)
    lint.linters_by_ft = {
      -- Go
      go = { "golangcilint" },

      -- JavaScript/TypeScript - Using custom biome linter
      javascript = { "biome" },
      typescript = { "biome" },
      javascriptreact = { "biome" },
      typescriptreact = { "biome" },
      json = { "biome" },
      jsonc = { "biome" },

      -- Lua
      lua = { "luacheck" },

      -- Shell
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },

      -- PHP/Laravel
      php = { "pint" },

      -- You can add more linters here as needed
      -- python = { "flake8", "mypy" },
      -- rust = { "clippy" },
    }

    -- Helper function to safely try linting
    local function safe_lint()
      local filetype = vim.bo.filetype
      local linters = lint.linters_by_ft[filetype]

      if not linters or #linters == 0 then
        return
      end

      -- Check if linters are actually available before trying to use them
      local available_linters = {}
      for _, linter_name in ipairs(linters) do
        if lint.linters[linter_name] then
          -- For custom linters, check if the command is executable
          local linter_config = lint.linters[linter_name]
          if linter_config.cmd and vim.fn.executable(linter_config.cmd) == 1 then
            table.insert(available_linters, linter_name)
          else
            vim.notify(
              string.format(
                "Linter '%s' command not executable: %s",
                linter_name,
                linter_config.cmd or "unknown"
              ),
              vim.log.levels.WARN,
              { title = "nvim-lint" }
            )
          end
        else
          -- For built-in linters, try to require them
          local ok = pcall(function()
            return require("lint.linters." .. linter_name)
          end)

          if ok then
            table.insert(available_linters, linter_name)
          else
            vim.notify(
              string.format("Linter '%s' not available for %s", linter_name, filetype),
              vim.log.levels.WARN,
              { title = "nvim-lint" }
            )
          end
        end
      end

      if #available_linters > 0 then
        local success, err = pcall(lint.try_lint, available_linters)
        if not success then
          vim.notify(
            string.format("Linting failed: %s", err),
            vim.log.levels.ERROR,
            { title = "nvim-lint" }
          )
        end
      end
    end

    -- Auto-lint on save and text changes
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = safe_lint,
    })

    -- Manual linting command
    vim.keymap.set("n", "<leader>ll", function()
      safe_lint()
      vim.notify("Linting triggered...", vim.log.levels.INFO, { title = "nvim-lint" })
    end, { desc = "Trigger linting for current file" })

    -- Show linter status
    vim.keymap.set("n", "<leader>li", function()
      local filetype = vim.bo.filetype
      local linters = lint.linters_by_ft[filetype] or {}

      if #linters == 0 then
        print("No linters configured for filetype: " .. filetype)
        return
      end

      print("Configured linters for " .. filetype .. ":")
      for _, linter_name in ipairs(linters) do
        local status = "❌ Not available"

        if lint.linters[linter_name] then
          -- Custom linter
          local cmd = lint.linters[linter_name].cmd
          if vim.fn.executable(cmd) == 1 then
            status = "✅ Available (custom) - " .. cmd
          else
            status = "⚠️  Custom linter but command not found: " .. cmd
          end
        else
          -- Built-in linter
          local ok = pcall(function()
            return require("lint.linters." .. linter_name)
          end)

          if ok then
            status = "✅ Available (built-in)"
          end
        end

        print(string.format("  %s: %s", linter_name, status))
      end

      -- Show biome-specific info
      if vim.tbl_contains(linters, "biome") then
        print("\nBiome configuration:")
        print("  Command: " .. biome_cmd)
        print("  Executable: " .. (vim.fn.executable(biome_cmd) == 1 and "✅ Yes" or "❌ No"))

        -- Test biome version
        local handle = io.popen(biome_cmd .. " --version 2>/dev/null")
        if handle then
          local version = handle:read("*a")
          handle:close()
          if version and version ~= "" then
            print("  Version: " .. version:gsub("\n", ""))
          end
        end
      end
    end, { desc = "Show available linters for current filetype" })

    -- Test biome command (useful for debugging)
    vim.keymap.set("n", "<leader>lb", function()
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == "" then
        vim.notify("Buffer has no filename", vim.log.levels.WARN)
        return
      end

      local cmd = string.format(
        "%s lint --stdin-file-path '%s' --diagnostic-level=info --reporter=json",
        biome_cmd,
        bufname
      )
      vim.notify("Testing biome with: " .. cmd, vim.log.levels.INFO)

      -- Get buffer content
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local content = table.concat(lines, "\n")

      -- Run biome
      local handle = io.popen(cmd, "w")
      if handle then
        handle:write(content)
        handle:close()
        vim.notify("Biome test completed - check output", vim.log.levels.INFO)
      else
        vim.notify("Failed to run biome command", vim.log.levels.ERROR)
      end
    end, { desc = "Test biome linter" })
  end,
}
