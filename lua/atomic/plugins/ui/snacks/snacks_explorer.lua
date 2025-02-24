return {
  "folke/snacks.nvim",
  opts = {
    explor = {},
  },
  keys = {
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
  },
}
