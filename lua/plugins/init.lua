return {
	{

		"nvim-lua/plenary.nvim", -- lua functions that many plugins use
		"christoomey/vim-tmux-navigator", -- tmux & split window navigation
	},
	{
		"adelarsq/image_preview.nvim",
		event = "VeryLazy",
		config = function()
			require("image_preview").setup()
		end,
	},
}
