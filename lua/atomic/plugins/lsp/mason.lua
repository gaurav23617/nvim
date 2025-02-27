return {
  "williamboman/mason.nvim",
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  build = function()
    pcall(vim.cmd, "MasonUpdate") -- Auto-update Mason
  end,

  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },

  config = function(_, opts)
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup(opts)

    -- Configure Mason LSP
    mason_lspconfig.setup({
      ensure_installed = {
        "biome",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "jsonls",
      },
      automatic_installation = true,
    })

    -- Install Additional Tools
    mason_tool_installer.setup({
      ensure_installed = {
        "biome",
        "stylua",
        "shfmt",
        "prettier",
        "eslint_d",
      },
    })

    -- REMOVE THIS TO PREVENT MASON UI FROM OPENING AUTOMATICALLY
    -- vim.defer_fn(function()
    --   require("mason.ui").open()
    -- end, 100)
  end,
}
