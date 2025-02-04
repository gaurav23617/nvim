return {
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use
	"christoomey/vim-tmux-navigator", -- tmux & split window navigation
	{ "echasnovski/mini.animate", version = false },
	{
		"mg979/vim-visual-multi",
		branch = "master",
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-d>",
			}
		end,
	},
	{
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},
	{ "nvzone/volt", lazy = true },
	{
		"nvzone/menu",
		lazy = true,
		config = function()
			require("menu").open(options, opts)
			-- Keyboard users
			vim.keymap.set("n", "<C-t>", function()
				require("menu").open("default")
			end, {})

			-- mouse users + nvimtree users!
			vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
				require("menu.utils").delete_old_menus()

				vim.cmd.exec('"normal! \\<RightMouse>"')

				-- clicked buf
				local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
				local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

				require("menu").open(options, { mouse = true })
			end, {})
		end,
	},
	{
		"nvzone/showkeys",
		cmd = "ShowkeysToggle",
		opts = {
			timeout = 1,
			maxkeys = 5,
			-- more opts
		},
	},
	{
		"nvzone/minty",
		cmd = { "Shades", "Huefy" },
	},
	{
		"echasnovski/mini.move",
		version = false,
		-- Module mappings. Use `''` (empty string) to disable one.
		mappings = {
			-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
			left = "<M-h>",
			right = "<M-l>",
			down = "<M-j>",
			up = "<M-k>",

			-- Move current line in Normal mode
			line_left = "<M-h>",
			line_right = "<M-l>",
			line_down = "<M-j>",
			line_up = "<M-k>",
		},

		-- Options which control moving behavior
		options = {
			-- Automatically reindent selection during linewise vertical move
			reindent_linewise = true,
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		keys = {
			{
				"<leader>mp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
}
