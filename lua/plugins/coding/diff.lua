return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Open DiffView for git" },
    { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close DiffView for git" },
  },
}
