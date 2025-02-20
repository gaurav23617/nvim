return {
  "saghen/blink.cmp",
  event = { "InsertEnter" },
  dependencies = {
    "moyiz/blink-emoji.nvim",
    "Kaiser-Yang/blink-cmp-dictionary",
    "rafamadriz/friendly-snippets",
    "folke/lazydev.nvim",
  },
  version = "*",
  config = function()
    local blink_cmp = require("blink.cmp")

    blink_cmp.setup({
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        ghost_text = { enabled = true, show_with_selection = true },
        menu = { auto_show = true },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = { name = "LSP", module = "blink.cmp.sources.lsp", min_keyword_length = 2 },
          path = { name = "Path", module = "blink.cmp.sources.path", min_keyword_length = 2 },
          buffer = { name = "Buffer", module = "blink.cmp.sources.buffer", min_keyword_length = 4 },
          snippets = {
            name = "Snippets",
            module = "blink.cmp.sources.snippets",
            min_keyword_length = 2,
          },
        },
      },
    })
  end,
}
