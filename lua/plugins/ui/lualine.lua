return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "folke/noice.nvim", opts = {} }, -- Noice plugin for enhancing the command-line UI
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
		local noice = require("noice")

		-- Function to display macro recording status
		local function macro_recording()
			local recording_register = vim.fn.reg_recording()
			if recording_register ~= "" then
				return "Recording @" .. recording_register
			end
			return ""
		end

		-- configure lualine with command-line integration via noice.nvim and macro recording status
		lualine.setup({
			options = {
				icons_enabled = true,
				theme = "catppuccin",
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
						function()
							return noice.api.status.command.get()
						end,
						cond = function()
							return noice.api.status.command.has()
						end,
						color = { fg = "#cdd6f4" },
					},
					{
						macro_recording, -- Displays macro recording status
						cond = function()
							return vim.fn.reg_recording() ~= ""
						end,
						color = { fg = "#ff0000" }, -- Highlight macro recording
					},
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
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
