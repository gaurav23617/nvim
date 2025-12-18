return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "neovim/nvim-lspconfig",
    "folke/lazydev.nvim",
  },
  version = "1.*",
  opts_extend = {
    "sources.completion.enabled_providers",
    "sources.compat",
    "sources.default",
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "default" },

    appearance = {
      nerd_font_variant = "mono",
    },

    signature = {
      enabled = true,
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },

      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
        },
      },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
  },
}
