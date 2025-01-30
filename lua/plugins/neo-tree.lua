return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required dependency for neo-tree
		"MunifTanjim/nui.nvim", -- UI components
		"3rd/image.nvim",
		"nvim-tree/nvim-web-devicons", -- for file icons
		"saifulapm/neotree-file-nesting-config", -- add plugin as dependency for nesting rules
		{
			"s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
			version = "2.*",
			config = function()
				require("window-picker").setup({
					filter_rules = {
						include_current_win = false,
						autoselect_one = true,
						-- filter using buffer options
						bo = {
							-- if the file type is one of following, the window will be ignored
							filetype = { "neo-tree", "neo-tree-popup", "notify" },
							-- if the buffer type is one of following, the window will be ignored
							buftype = { "terminal", "quickfix" },
						},
					},
				})
			end,
		},
	},
	config = function()
		local neotree = require("neo-tree")

		-- Recommended settings from neo-tree documentation
		neotree.setup({
			nesting_rules = require("neotree-file-nesting-config").nesting_rules,
			window = {
				width = 28,
				position = "right",
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["<space>"] = {
						"toggle_node",
						nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
					},
				},
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				follow_current_file = {
					enabled = true, -- Focus on the current file in the explorer
				},
			},
			renderer = {
				icons = {
					folder = {
						arrow_closed = "", -- arrow when folder is closed
						arrow_open = "", -- arrow when folder is open
					},
				},
			},
			git_status = {
				enabled = true, -- Show git status in the tree
				icons = {
					ignored = "◌",
				},
			},
		})

		-- Set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set("i", "<C-B>", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set("n", "<leader>ef", "<cmd>Neotree reveal<CR>", { desc = "Reveal file in file explorer" }) -- reveal current file
		keymap.set("n", "<leader>ec", "<cmd>Neotree close<CR>", { desc = "Close file explorer" }) -- close file explorer
		keymap.set("n", "<leader>er", "<cmd>Neotree refresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
	end,
}
