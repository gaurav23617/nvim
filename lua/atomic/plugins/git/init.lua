return {
  {
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
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    opts = {},
    keys = {
      { "<leader>gnn", "<cmd>Neogit<cr>", desc = "Neogit (Root Dir)" },
      { "<leader>gnc", "<cmd>Neogit commit<cr>", desc = "Commit" },
      { "<leader>gnp", "<cmd>Neogit pull<cr>", desc = "Pull" },
      { "<leader>gnP", "<cmd>Neogit push<cr>", desc = "Push" },
      { "<leader>gnf", "<cmd>Neogit fetch<cr>", desc = "Fetch" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>gn", group = "neogit", icon = " " },
      },
    },
  },
}
