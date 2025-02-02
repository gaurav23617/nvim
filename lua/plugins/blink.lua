return {
	"saghen/blink.cmp",
	enabled = true,
	dependencies = {
		"moyiz/blink-emoji.nvim",
		"Kaiser-Yang/blink-cmp-dictionary",
		"rafamadriz/friendly-snippets",
		{
			"saghen/blink.compat",
			optional = true,
			opts = {},
		},
	},
	event = "InsertEnter",
	config = function()
		require("blink.cmp").setup({
			opts = function(_, opts)
				opts.enabled = function()
					local disabled_filetypes = {
						TelescopePrompt = true,
						minifiles = true,
						snacks_picker_input = true,
					}
					return not disabled_filetypes[vim.bo.filetype]
				end

				opts.sources = {
					default = { "lsp", "path", "snippets", "buffer", "copilot", "dadbod", "emoji", "dictionary" },
					providers = {
						markdown = {
							name = "RenderMarkdown",
							module = "render-markdown.integ.blink",
							fallbacks = { "lsp" },
						},
						lsp = {
							name = "LSP",
							module = "blink.cmp.sources.lsp",
							enabled = true,
							min_keyword_length = 2,
							score_offset = 90,
						},
						path = {
							name = "Path",
							module = "blink.cmp.sources.path",
							min_keyword_length = 2,
							fallbacks = { "snippets", "buffer" },
						},
						buffer = {
							name = "Buffer",
							module = "blink.cmp.sources.buffer",
							min_keyword_length = 4,
							max_items = 5,
						},
						snippets = {
							name = "Snippets",
							module = "blink.cmp.sources.snippets",
							min_keyword_length = 2,
							max_items = 15,
							should_show_items = function()
								local col = vim.api.nvim_win_get_cursor(0)[2]
								local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
								return before_cursor:match(";(%w*)$") ~= nil
							end,
							transform_items = function(_, items)
								local col = vim.api.nvim_win_get_cursor(0)[2]
								local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
								local trigger_pos = before_cursor:find(";%w*$")
								if trigger_pos then
									for _, item in ipairs(items) do
										item.textEdit = {
											newText = item.insertText or item.label,
											range = {
												start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
												["end"] = { line = vim.fn.line(".") - 1, character = col },
											},
										}
									end
								end
								vim.schedule(function()
									require("blink.cmp").reload("snippets")
								end)
								return items
							end,
						},
						emoji = {
							module = "blink-emoji",
							name = "Emoji",
							min_keyword_length = 2,
						},
						dictionary = {
							module = "blink-cmp-dictionary",
							name = "Dictionary",
							min_keyword_length = 3,
							opts = {
								dictionary_directories = { vim.fn.stdpath("config") .. "/dictionaries" },
								dictionary_files = {
									vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
									vim.fn.stdpath("config") .. "/spell/es.utf-8.add",
								},
							},
						},
					},
				}

				opts.completion = {
					ghost_text = { enabled = true },
					documentation = { auto_show = true, window = { border = "single" } },
					menu = { border = "single" },
					accept = {
						auto_brackets = { enabled = true },
					},
				}

				opts.keymap = {
					preset = "default",
					["<Tab>"] = { "snippet_forward", "fallback" },
					["<S-Tab>"] = { "snippet_backward", "fallback" },
					["<C-k>"] = { "select_prev", "fallback" },
					["<C-j>"] = { "select_next", "fallback" },
					["<C-b>"] = { "scroll_documentation_up", "fallback" },
					["<C-f>"] = { "scroll_documentation_down", "fallback" },
					["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
					["<C-e>"] = { "hide", "fallback" },
					["<CR>"] = { "select_and_accept" }, -- Accept completion with Enter
				}

				return opts
			end,
		})
	end,
}
