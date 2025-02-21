return {
  "folke/snacks.nvim",
  opts = {
    explorer = {},
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
