return {
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use
	"christoomey/vim-tmux-navigator", -- tmux & split window navigation
	{
		"onsails/lspkind.nvim",
		lazy = true,
		opts = {
			mode = "symbol",
			symbol_map = {
				Array = "󰅪",
				Boolean = "⊨",
				Class = "󰌗",
				Constructor = "",
				Key = "󰌆",
				Namespace = "󰅪",
				Null = "NULL",
				Number = "#",
				Object = "󰀚",
				Package = "󰏗",
				Property = "",
				Reference = "",
				Snippet = "",
				String = "󰀬",
				TypeParameter = "󰊄",
				Unit = "",
			},
			menu = {},
		},
	},
}
