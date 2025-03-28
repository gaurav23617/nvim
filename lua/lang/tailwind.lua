return {
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<leader>cT", "<cmd>TWValues<cr>", desc = "Tailwind CSS values" },
    },
    opts = {},
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "tailwindcss",
      },
    },
  },
}
