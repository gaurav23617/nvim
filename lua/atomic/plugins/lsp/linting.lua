return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Function to check if `biome.json` or `biome.jsonc` exists in the project root
    local function has_biome_config()
      local biome_files = { "biome.json", "biome.jsonc", "biome.toml" }
      local root = vim.fn.getcwd() -- Get project root directory

      for _, file in ipairs(biome_files) do
        if vim.fn.filereadable(root .. "/" .. file) == 1 then
          return true
        end
      end
      return false
    end

    -- Custom JSON Parser for Biome Output
    local function biome_json_parser(output, bufnr)
      local diagnostics = {}
      local decoded = vim.fn.json_decode(output)

      if not decoded or type(decoded) ~= "table" then
        return diagnostics
      end

      for _, diagnostic in ipairs(decoded.diagnostics or {}) do
        table.insert(diagnostics, {
          bufnr = bufnr,
          lnum = (diagnostic.span.start.line or 1) - 1,
          col = (diagnostic.span.start.character or 1) - 1,
          end_lnum = (diagnostic.span["end"].line or 1) - 1,
          end_col = (diagnostic.span["end"].character or 1) - 1,
          severity = diagnostic.severity == "error" and vim.diagnostic.severity.ERROR
            or vim.diagnostic.severity.WARN,
          source = "biome",
          message = diagnostic.message,
        })
      end

      return diagnostics
    end

    -- Define Biome Linter
    lint.linters.biome = {
      cmd = "biome",
      stdin = false,
      append_fname = true,
      args = { "check", "--output-format", "json" },
      stream = "stdout",
      ignore_exitcode = true,
      parser = biome_json_parser,
    }

    -- Function to return the correct linter table dynamically
    local function get_linter_for_ft()
      if has_biome_config() then
        return { "biome" }
      else
        return { "eslint_d", "eslint" }
      end
    end

    -- Define ESLint as a fallback
    lint.linters_by_ft = {
      javascript = get_linter_for_ft(),
      typescript = get_linter_for_ft(),
      javascriptreact = get_linter_for_ft(),
      typescriptreact = get_linter_for_ft(),
      svelte = { "eslint_d", "eslint" }, -- Svelte always uses ESLint
    }

    -- Auto Linting on File Open, Save, or Leaving Insert Mode
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Manual Linting Keymap
    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
