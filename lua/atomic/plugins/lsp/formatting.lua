return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

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

    -- Define formatters dynamically based on the project setup
    local function get_formatters(ft)
      -- List of formatters for specific file types
      local formatters = {
        svelte = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        php = { "php_cs_fixer" },
        liquid = { "prettier" },
        lua = { "stylua" },
      }

      -- Filetypes that should use Biome if available
      local biome_supported = {
        javascript = true,
        typescript = true,
        javascriptreact = true,
        typescriptreact = true,
        css = true,
        html = true,
        json = true,
        graphql = true,
      }

      -- Use Biome if the project has a Biome config
      if biome_supported[ft] and has_biome_config() then
        return { "biome" }
      end

      -- Return predefined formatters or an empty table if none exist
      return formatters[ft] or {}
    end

    -- Generate formatters table dynamically
    local formatters_by_ft = {}
    local filetypes = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "css",
      "html",
      "json",
      "yaml",
      "markdown",
      "graphql",
      "lua",
    }

    for _, ft in ipairs(filetypes) do
      formatters_by_ft[ft] = get_formatters(ft)
    end

    -- Set up Conform with the generated formatters
    conform.setup({
      formatters_by_ft = formatters_by_ft,
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    -- Manual Formatting Keymap
    vim.keymap.set({ "n", "v" }, "<leader>mf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
