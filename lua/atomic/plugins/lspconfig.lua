return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    { "antosha417/nvim-lsp-file-operations", config = true },
    "folke/lazydev.nvim",
    "saghen/blink.cmp",
    { "jose-elias-alvarez/null-ls.nvim", config = true }, -- Ensure null-ls is configured
    { "folke/snacks.nvim", config = true }, -- Add Snacks plugin
  },
  config = function() end,
}
