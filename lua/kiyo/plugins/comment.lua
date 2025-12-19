return {
  { "nvim-mini/mini.comment", version = "*" },
  {
    "folke/ts-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
