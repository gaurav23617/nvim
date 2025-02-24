return {
  {
    "nvim-tree/nvim-web-devicons",
  },
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "szw/vim-maximizer",
    keys = {
      { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
    },
  },
  {
    "brianhuster/live-preview.nvim",
    cmd = "LivePreview",
    require("livepreview.config").set({
      port = 5500,
      browser = "default",
      dynamic_root = false,
      sync_scroll = false,
      picker = "",
    }),
  },
}
