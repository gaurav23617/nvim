return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local keymap = vim.keymap

		local capabilities = vim.lsp.protocol.make_client_capabilities() -- No cmp-nvim-lsp

		-- Define default setup for all LSP servers
		local default_setup = function(server)
			lspconfig[server].setup({
				capabilities = capabilities,
			})
		end

		-- Set up key bindings when an LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = {
					buffer = ev.buf,
					silent = true,
				}

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				default_setup(server_name)
			end,
			["lua_ls"] = function()
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							completion = { callSnippet = "Replace" },
						},
					},
				})
			end,
			["biome"] = function()
				lspconfig.biome.setup({
					capabilities = capabilities,
					cmd = { "biome", "lsp-proxy" },
					filetypes = { "javascript", "typescript", "json", "jsonc", "vue", "svelte", "css", "astro" },
					root_dir = require("lspconfig.util").root_pattern("biome.json", "biome.jsonc", ".git"),
					settings = {
						biome = {
							formatter = {
								enabled = true,
								indentStyle = "tab",
								formatWithErrors = false,
								lineWidth = 100,
								lineEnding = "lf",
							},
							files = {
								ignore = { "dist", "node_modules", ".git" },
							},
							organizeImports = {
								enabled = true,
							},
							linter = {
								enabled = true,
								rules = {
									recommended = true,
									correctness = {
										noUnsafeFinally = "error",
										noUnusedVariables = "error",
									},
									suspicious = {
										noDoubleEquals = "error",
										useNamespaceKeyword = "error",
									},
								},
							},
						},
					},
				})
			end,
			["tailwindcss"] = function()
				lspconfig.tailwindcss.setup({
					capabilities = capabilities,
				})
			end,
		})
	end,
}
