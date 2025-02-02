return {
	"3rd/image.nvim",
	event = "VeryLazy",
	config = function()
		local image = require("image")

		image.setup({
			backend = "kitty",
			kitty_method = "normal",

			-- 🔹 Fix: Force clear images on window switch (Tmux & Neovim)
			window_overlap_clear_enabled = true,
			window_overlap_clear_ft_ignore = {
				"cmp_menu",
				"cmp_docs",
				"telescope",
				"which_key",
				"lazy",
				"mason",
				"",
			},

			-- 🔹 Fix: Completely hide images when switching windows or Tmux panes
			tmux_show_only_in_active_window = false, -- Force-clear images when changing Tmux panes

			-- 🔹 Extra Fix: Ensure images are properly removed when switching buffers
			autocmd_clear_images_on_switch = true,

			-- 🔹 More Aggressive Clearing: Use Neovim AutoCmds
			autocmds = {
				{
					event = { "WinLeave", "BufLeave", "FocusLost" },
					callback = function()
						require("image").clear() -- Hide images when losing focus
					end,
				},
				{
					event = { "WinEnter", "BufEnter", "FocusGained" },
					callback = function()
						require("image").refresh() -- Refresh images when needed
					end,
				},
			},

			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = true, -- Clears image while typing
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki", "html" },
				},
				neorg = {
					enabled = true,
					clear_in_insert_mode = true,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "norg" },
				},
				html = {
					enabled = true,
					only_render_image_at_cursor = true,
					filetypes = { "html", "xhtml", "htm" },
				},
				css = {
					enabled = true,
				},
			},

			-- 🔹 Fix: Ensure images resize properly (auto-adjust to window size)
			max_width_window_percentage = 50,
			max_height_window_percentage = 50,

			-- 🔹 Fix: Prevents images from "sticking" when opening new files
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
		})

		-- 🔹 Extra Tmux Fix: Auto-clear images when switching Tmux panes
		vim.api.nvim_create_autocmd({ "VimLeavePre", "FocusLost" }, {
			callback = function()
				require("image").clear()
			end,
		})

		-- 🔹 Fix Floating Windows & Telescope Overlap
		vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
			pattern = { "TelescopePrompt", "cmp_menu", "lazy", "mason", "which_key" },
			callback = function()
				require("image").clear()
			end,
		})

		-- 🔹 Extra Debugging: Print when clearing images (Optional)
		-- vim.api.nvim_create_autocmd("WinLeave", {
		-- 	callback = function()
		-- 		print("Clearing Images...") -- Remove after debugging
		-- 	end,
		-- })
	end,
}
