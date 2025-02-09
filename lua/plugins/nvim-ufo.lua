return {
	"kevinhwang91/nvim-ufo",
  enabled = false,
  event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{ "kevinhwang91/promise-async" },
	},
	config = function()
		local ufo = require("ufo")

		-- Ensure LSP capabilities support folding range
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		-- Update capabilities for all LSPs that support folding
		local lspconfig = require("lspconfig")
		for _, ls in ipairs(vim.lsp.get_active_clients()) do
			if lspconfig[ls.name] then
				lspconfig[ls.name].setup({
					capabilities = capabilities,
				})
			end
		end

		-- UFO Setup with FIXED provider selection
		ufo.setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "lsp", "indent" } -- Treesitter is removed to avoid unexpected auto-folding
			end,
			open_fold_hl_timeout = 0, -- Prevent delay in opening folds
			close_fold_kinds = {}, -- Prevents automatic fold closing
		})

		-- Ensure folds are NOT closed on startup
		vim.opt.foldlevel = 99 -- Large enough to keep everything open
		vim.opt.foldlevelstart = 99 -- Open all folds at the start
		vim.opt.foldenable = true -- Keep folding available but not forced

		-- Keymaps for UFO
		vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
		vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
		vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open folds except certain kinds" })
		vim.keymap.set("n", "zm", ufo.closeFoldsWith, { desc = "Close folds with level" }) -- closeAllFolds == closeFoldsWith(0)

		-- Peek folded lines or show hover
		vim.keymap.set("n", "K", function()
			local winid = ufo.peekFoldedLinesUnderCursor()
			if not winid then
				if vim.fn.exists("*CocActionAsync") == 1 then
					vim.fn.CocActionAsync("definitionHover") -- coc.nvim
				else
					vim.lsp.buf.hover()
				end
			end
		end, { desc = "Peek folded lines or show hover" })
	end,
}
