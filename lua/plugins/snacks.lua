return {
	"folke/snacks.nvim",
	priority = 700,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = {
			enabled = false,
		},
		indent = {
			enabled = false,
		},
		dashboard = { example = "advanced" },
		input = {
			enabled = false,
		},
		notifier = {
			enabled = false,
		},
		quickfile = {
			enabled = false,
		},
		scroll = {
			enabled = true,
		},
		statuscolumn = {
			enabled = false,
		},
		words = {
			enabled = false,
		},
	},
}
