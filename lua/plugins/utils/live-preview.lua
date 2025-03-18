return {
  "brianhuster/live-preview.nvim",
  cmd = "LivePreview",
  opts = {
    port = 5500,
    browser = "default",
    dynamic_root = false,
    sync_scroll = false,
    picker = "",
  },
  keys = {
    { "<leader>lv", "<cmd>LivePreview start<cr>" },
    { "<leader>lx", "<cmd>LivePreview stop<cr>" },
  },
}
