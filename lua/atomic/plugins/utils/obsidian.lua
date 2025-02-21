return {
  "epwalsh/obsidian.nvim",
  version = "*",
  enabled = false,
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/obsidian/brain-log/",
      },
    },
  },
}
