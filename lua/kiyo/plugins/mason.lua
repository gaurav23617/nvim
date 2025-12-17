return {
  -- Mason: LSP server installer and manager
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },

  -- Mason-lspconfig: Bridge between mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        -- Auto-install these LSP servers
        ensure_installed = {
          -- Web Development
          "ts_ls",           -- TypeScript/JavaScript
          "html",            -- HTML
          "cssls",           -- CSS
          "tailwindcss",     -- TailwindCSS
          "emmet_language_server", -- Emmet

          -- Backend
          "lua_ls",          -- Lua
          "pyright",         -- Python
          "gopls",           -- Go
          "rust_analyzer",   -- Rust

          -- Add more servers as needed:
          -- "jsonls",       -- JSON
          -- "yamlls",       -- YAML
          -- "dockerls",     -- Docker
          -- "bashls",       -- Bash
        },

        -- Auto-install servers configured in lsp.lua
        automatic_installation = true,
      })
    end
  }
}
