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

    -- Custom biome linter configuration
    lint.linters.biome = {
      cmd = function()
        -- Try Mason-installed biome first, then system biome
        local mason_biome = mason_bin_dir .. "/biome"
        if vim.fn.executable(mason_biome) == 1 then
          return mason_biome
        end
        return "biome"
      end,
      stdin = true,
      args = {
        "check",
        "--stdin-file-path",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      },
      stream = "stderr",
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}

        if not output or output == "" then
          return diagnostics
        end

        -- Parse biome check output (simplified parser)
        for line in output:gmatch("[^\r\n]+") do
          -- Look for error/warning patterns in biome output
          local lnum, col, severity, message = line:match("(%d+):(%d+)%s+(%w+)%s+(.+)")
          if lnum and message then
            table.insert(diagnostics, {
              lnum = tonumber(lnum) - 1,
              col = tonumber(col) - 1,
              message = message,
              severity = severity:lower() == "error" and vim.diagnostic.severity.ERROR
                or vim.diagnostic.severity.WARN,
              source = "biome",
            })
          end
        end

        return diagnostics
      end,
    }

    -- Configure linters by filetype (removed biome from JS/TS since it's better used as LSP)
    lint.linters_by_ft = {
      -- Go
      go = { "golangcilint" },

      -- JavaScript/TypeScript - use eslint_d instead of biome for linting
      -- Biome works better as an LSP server for diagnostics
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },

      -- Lua
      lua = { "luacheck" },

      -- Shell
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },

      -- PHP/Laravel
      php = { "pint" },

      -- You can add biome back if you want to use it as a linter
      -- But it's recommended to use it as LSP instead
      -- javascript = { "biome" },
      -- typescript = { "biome" },
    }

    -- Auto-lint on save and text changes
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Only lint if linters are available for this filetype
        local linters = lint.linters_by_ft[vim.bo.filetype]
        if linters and #linters > 0 then
          -- Check if the linter is actually available before trying to lint
          for _, linter_name in ipairs(linters) do
            local linter = lint.linters[linter_name]
            if linter then
              local cmd = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
              if vim.fn.executable(cmd) == 1 then
                lint.try_lint(linter_name)
                break
              else
                vim.notify("Linter '" .. linter_name .. "' not found: " .. cmd, vim.log.levels.WARN)
              end
            end
          end
        end
      end,
    })

    -- Manual linting command
    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
      vim.notify("Linting...", vim.log.levels.INFO, { title = "nvim-lint" })
    end, { desc = "Trigger linting for current file" })

    -- Show linter status
    vim.keymap.set("n", "<leader>li", function()
      local linters = lint.linters_by_ft[vim.bo.filetype] or {}
      if #linters == 0 then
        print("No linters configured for filetype: " .. vim.bo.filetype)
      else
        print("Linters for " .. vim.bo.filetype .. ": " .. table.concat(linters, ", "))

        -- Show which tools are being used
        if vim.bo.filetype == "php" then
          if string.find(pint_cmd, "mason") then
            print("Using Mason pint: " .. pint_cmd)
          else
            print("Using system pint: " .. pint_cmd)
          end
        end
      end
    end, { desc = "Show available linters for current filetype" })
  end,
}
