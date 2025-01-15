return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "folke/noice.nvim", opts = {} }, -- Noice plugin for enhancing the command line UI
	},
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			-- set an empty statusline till lualine loads
			vim.o.statusline = " "
		else
			-- hide the statusline on the starter page
			vim.o.laststatus = 0
		end
	end,
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- configure lualine with command-line integration via noice.nvim
		lualine.setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
				globalstatus = true, -- Enables a global statusline
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{
						"noice_command", -- Displays command line input handled by noice.nvim
						cond = function()
							return require("noice").api.status.command.has()
						end,
						color = { fg = "#00ffcc" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "quickfix", "fugitive" },
		})
	end,
}
