return {
  "saghen/blink.cmp",
  event = { "InsertEnter" },
  dependencies = {
    { "L3MON4D3/LuaSnip", version = "v2.*" },
    "hrsh7th/nvim-cmp",
    "onsails/lspkind.nvim",
    "hrsh7th/nvim-cmp",
    "neovim/nvim-lspconfig",
    "moyiz/blink-emoji.nvim",
    "Kaiser-Yang/blink-cmp-dictionary",
    "rafamadriz/friendly-snippets",
    "folke/lazydev.nvim",
  },
  version = "*",
  config = function()
    local blink_cmp = require("blink.cmp")
    local lspkind = require("lspkind")

    blink_cmp.setup({
      fuzzy = {
        sorts = {
          function(a, b)
            if a.client_name == nil or b.client_name == nil then
              return
            end
            return b.client_name == "emmet_ls"
          end,
          -- default sorts
          "score",
          "sort_text",
        },
      },

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

        accept = {
          create_undo_point = true,
          resolve_timeout_ms = 500,
          auto_brackets = {
            enabled = true,
            default_brackets = { "(", ")" },
            override_brackets_for_filetypes = {},
            kind_resolution = {
              enabled = true,
              blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
            },
            semantic_token_resolution = {
              enabled = true,
              blocked_filetypes = { "java" },
              timeout_ms = 400,
            },
          },
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },

        menu = {
          auto_show = true,
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          draw = {
            treesitter = {
              "lsp",
            },
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local lspkind = require("lspkind")
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },

        ghost_text = {
          enabled = true,
          show_with_selection = true,
        },
      },

      snippets = {
        preset = "luasnip",
        expand = function(snippet)
          vim.snippet.expand(snippet)
        end,
        active = function(filter)
          return vim.snippet.active(filter)
        end,
        jump = function(direction)
          vim.snippet.jump(direction)
        end,
      },

      sources = {
        default = {
          "dictionary",
          "lazydev",
          "lsp",
          "path",
          "snippets",
          "buffer",
          "emoji",
          "cmdline",
          "omni",
        },
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
            opts = {
              get_bufnrs = function()
                return vim.tbl_filter(function(bufnr)
                  return vim.bo[bufnr].buftype == ""
                end, vim.api.nvim_list_bufs())
              end,
            },
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
