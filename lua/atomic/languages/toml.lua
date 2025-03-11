return {
  recommended = function()
    return {
      ft = "toml",
      root = { "*.toml" },
    }
  end,
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      taplo = {},
    },
  },
}
