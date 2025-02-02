return {
	"saghen/blink.cmp",
	dependencies = {
		"moyiz/blink-emoji.nvim",
		"Kaiser-Yang/blink-cmp-dictionary",
		"rafamadriz/friendly-snippets",
		"folke/lazydev.nvim",
		-- "mrcjkb/haskell-tools.nvim",
		"hrsh7th/nvim-cmp",
	},
	version = "*",
	event = { "InsertEnter" },
	opts_extend = { "sources.default" },
	config = function()
		-- Safe import of nvim-cmp
		local cmp_ok, cmp = pcall(require, "cmp")
		if not cmp_ok then
			return
		end

		-- Safe import of blink-cmp
		local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
		if not blink_cmp_ok then
			return
		end

		blink_cmp.setup({
			-- 'default', 'super-tab', 'enter'

			keymap = {
				preset = "enter", -- ✨ Potential Issue Here
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-J>"] = { "select_next", "snippet_forward", "fallback" },
				["<C-K>"] = { "select_prev", "snippet_backward", "fallback" },
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
