return {
  'saghen/blink.cmp',
  -- Optional: provides snippets for the snippet source
  dependencies = {
    'rafamadriz/friendly-snippets'
  },
  -- Use a release tag to download pre-built binaries
  version = '1.*',

  -- Build from source, requires nightly Rust
  -- Uncomment if you want to build from source:
  -- build = 'cargo build --release',

  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- Keymap presets:
    -- 'default' (recommended) - C-y to accept, similar to built-in completion
    -- 'super-tab' - Tab to accept, similar to VSCode
    -- 'enter' - Enter to accept
    -- 'none' - No default mappings
    --
    -- All presets include:
    -- C-space: Open menu or docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for custom keymaps
    keymap = { preset = 'default' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- Signature help configuration
    signature = {
      enabled = true
    },

    -- Documentation popup configuration
    completion = {
      -- Show documentation automatically when selecting items
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },

      -- Menu configuration
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
        }
      }
    },

    -- Default list of enabled providers
    -- Defined here so you can extend it elsewhere in your config
    -- without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      -- Optionally disable cmdline completion
      -- cmdline = {},
    },

    -- Rust fuzzy matcher for typo resistance and better performance
    -- Options:
    -- - "prefer_rust_with_warning" (recommended): Use Rust, warn if unavailable
    -- - "rust": Force Rust implementation
    -- - "lua": Use Lua implementation
    fuzzy = {
      implementation = "prefer_rust_with_warning"
    }
  },

  -- Important for extending sources.default elsewhere in your config
  opts_extend = { "sources.default" }
}
