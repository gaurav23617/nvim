return {
  "saghen/blink.cmp",
  event = { "InsertEnter" },
  dependencies = {
    { "L3MON4D3/LuaSnip", version = "v2.*" },
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
        ["<C-J>"] = { "select_next", "snippet_forward", "fallback" },
        ["<C-K>"] = { "select_prev", "snippet_backward", "fallback" },
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
      snippets = { preset = "luasnip" },
      sources = {
        default = { "dictionary", "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            min_keyword_length = 2,
            score_offset = 90,
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 25,
            fallbacks = { "snippets", "buffer" },
            min_keyword_length = 2,
          },
          buffer = {
            name = "Buffer",
            enabled = true,
            max_items = 3,
            module = "blink.cmp.sources.buffer",
            min_keyword_length = 4,
            score_offset = 15,
          },
          snippets = {
            name = "snippets",
            enabled = true,
            max_items = 15,
            min_keyword_length = 2,
            module = "blink.cmp.sources.snippets",
            score_offset = 85,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 15,
            min_keyword_length = 2,
            opts = { insert = true },
          },
          dictionary = {
            name = "Dict",
            module = "blink-cmp-dictionary",
            score_offset = 20,
            enabled = true,
            max_items = 8,
            min_keyword_length = 3,
            opts = {
              dictionary_directories = { vim.fn.expand("~/.config/nvim/dictionaries") },
              dictionary_files = {
                vim.fn.expand("~/.config/nvim/spell/en.utf-8.add"),
                vim.fn.expand("~/.config/nvim/spell/es.utf-8.add"),
              },
            },
          },
        },
      },
    })
  end,
}
