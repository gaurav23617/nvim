return {
  "folke/snacks.nvim",
  opts = {
    explorer = {},
    picker = {
      sources = {
        explorer = {
          layout = { preset = "sidebar", preview = false, layout = { position = "right" } },
          exclude = {
            ".git",
            "*.log",
            "build",
            "dist",
            "__pycache__",
            "*.tmp",
            "*.swp",
          },
          include = { "*" },
        },
      },
    },
  },
  keys = {
    {
      "<leader>fe",
      function()
        Snacks.explorer({ cwd = LazyVim.root() })
      end,
      desc = "Explorer Snacks (root dir)",
    },
    {
      "<leader>fE",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer Snacks (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
  },
}
