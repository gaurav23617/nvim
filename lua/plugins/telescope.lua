return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod
		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				file_ignore_patterns = { "^%.git[/\\]", "[/\\]%.git[/\\]" },
				path_display = { "truncate" },
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = { prompt_position = "bottom", preview_width = 0.55 },
					vertical = { mirror = false },
					width = 0.87,
					height = 0.80,
					preview_cutoff = 120,
				},
				winblend = 10,
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-p>"] = function()
							require("telescope.builtin").find_files({ previewer = false })
						end,
						["<CR>"] = actions.select_default,
					},
					n = {
						q = actions.close,
						["<CR>"] = actions.select_default,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- Key mappings
		local keymap = vim.keymap

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
		keymap.set("n", "<leader><Space>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
		keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Find Git files" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })
		keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find words" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find word under cursor" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
		keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
		keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Find history" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })
		keymap.set(
			"n",
			"<leader>f/",
			"<cmd>Telescope current_buffer_fuzzy_find<cr>",
			{ desc = "Find words in current buffer" }
		)
		keymap.set("n", "<leader>fC", "<cmd>Telescope commands<cr>", { desc = "Find commands" })
		keymap.set(
			"n",
			"<leader>fF",
			"<cmd>Telescope find_files hidden=true no_ignore=true<cr>",
			{ desc = "Find all files" }
		)
	end,
}
