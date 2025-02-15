return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>lv", "<cmd>DiffviewOpen<cr>", desc = "Open DiffView for git" },
    { "<leader>lc", "<cmd>DiffviewClose<cr>", desc = "Close DiffView for git" },
  },
}
