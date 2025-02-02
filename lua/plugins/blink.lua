return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "*",
	event = { "InsertEnter" },
	opts_extend = { "sources.default" },
	config = function()
		require("blink.cmp").setup({
			-- 'default', 'super-tab', 'enter'
			keymap = {
				preset = "enter",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			},
			completion = {
				list = {
					selection = {
						auto_insert = true,
						preselect = true,
					},
				},
				menu = { border = "rounded" },
				documentation = { window = { border = "rounded" } },
			},
			signature = { window = { border = "rounded" } },
			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				nerd_font_variant = "normal",
				kind_icons = require("lib.icons").kind,
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},
		})
	end,
}
