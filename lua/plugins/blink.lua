return {
	"saghen/blink.cmp",
	dependencies = {
		"moyiz/blink-emoji.nvim",
		"Kaiser-Yang/blink-cmp-dictionary",
		"rafamadriz/friendly-snippets",
		"folke/lazydev.nvim",
	},
	version = "*",
	event = { "InsertEnter" },
	config = function()
		-- Safe import of blink.cmp
		local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
		if not blink_cmp_ok then
			return
		end

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
				highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
				nerd_font_variant = "mono",
			},
			completion = {
				ghost_text = {
					enabled = true,
					-- Show the ghost text when an item has been selected
					show_with_selection = true,
					-- Show the ghost text when no item has been selected, defaulting to the first item
					show_without_selection = false,
				},
				menu = {
					enabled = true,
					min_width = 15,
					max_height = 10,
					border = "none",
					winblend = 0,
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
					-- Keep the cursor X lines away from the top/bottom of the window
					scrolloff = 2,
					-- Note that the gutter will be disabled when border ~= 'none'
					scrollbar = true,
					-- Which directions to show the window,
					-- falling back to the next direction when there's not enough space
					direction_priority = { "s", "n" },

					-- Whether to automatically show the window when new completion items are available
					auto_show = true,

					-- Screen coordinates of the command line
					cmdline_position = function()
						if vim.g.ui_cmdline_pos ~= nil then
							local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
							return { pos[1] - 1, pos[2] }
						end
						local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
						return { vim.o.lines - height, 0 }
					end,
				},
			},
			signature = {
				enabled = true,
				trigger = {
					-- Show the signature help automatically
					enabled = true,
					-- Show the signature help window after typing any of alphanumerics, `-` or `_`
					show_on_keyword = false,
					blocked_trigger_characters = {},
					blocked_retrigger_characters = {},
					-- Show the signature help window after typing a trigger character
					show_on_trigger_character = true,
					-- Show the signature help window when entering insert mode
					show_on_insert = false,
					-- Show the signature help window when the cursor comes after a trigger character when entering insert mode
					show_on_insert_on_trigger_character = true,
				},
				window = {
					min_width = 1,
					max_width = 100,
					max_height = 10,
					border = "padded",
					winblend = 0,
					winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
					scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
					-- Which directions to show the window,
					-- falling back to the next direction when there's not enough space,
					-- or another window is in the way
					direction_priority = { "n", "s" },
					-- Disable if you run into performance issues
					treesitter_highlighting = true,
					show_documentation = true,
				},
			},
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
							dictionary_directories = { vim.fn.expand("../../dictionaries") },
							dictionary_files = {
								vim.fn.expand("../../spell/en.utf-8.add"),
								vim.fn.expand("../../spell/es.utf-8.add"),
							},
						},
					},
				},
			},
		})
	end,
}
