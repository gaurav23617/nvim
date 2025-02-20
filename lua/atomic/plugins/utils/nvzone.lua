return {
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
}
