return {
  "mason-org/mason.nvim",
  event = "VeryLazy", -- Ensures Mason loads early
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  opts_extend = { "ensure_installed" },

  config = function()
    -- import mason and mason_lspconfig
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      automatic_enable = false,
      -- servers for mason to install
      ensure_installed = {
        "lua_ls",
        "ts_ls", -- if not using other TS plugin
        "html",
        "cssls",
        "tailwindcss",
        "gopls",
        "emmet_ls",
        "marksman",
        "biome",
        "phpactor",
        "intelephense",
        "pyright",
        "jsonls",
        "clangd",
        "prismals",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "eslint_d",
        "isort", -- python formatter
        "pylint",
        "clangd",
        "denols",
        "shfmt",
        "graphql-language-service-cli",
      },
    })
  end,
}
