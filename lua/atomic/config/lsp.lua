local lspconfig = require("lspconfig")

-- Add cmp capabilities (blink.cmp or fallback)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then
  capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
end

-- 1. Set default config for all LSP servers (applies to both mason and vim.lsp.enable)
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- 2. Mason-managed servers (auto-install + auto-setup)
require("mason-lspconfig").setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = capabilities,
    })
  end,
})

-- 3. Neovim 0.11+ new LSP bootstrap API
vim.lsp.enable({
  "tsserver", -- correct spelling
  "lua_ls",
  "tailwindcss",
  "eslint",
  "rust_analyzer",
  "gopls",
  "html",
  "cssls",
  "basedpyright",
  "bashls",
  "css_variables",
  "cssmodules_ls",
  "dockerls",
  "grammarly",
  "jsonls",
  "lemminx",
  "marksman",
  "nginx_language_server",
  "taplo",
  "yamlls",
})

-- 4. Diagnostic display with custom signs
vim.diagnostic.config({
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
  virtual_text = false,
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- 5. Enable inlay hints globally
vim.lsp.inlay_hint.enable(true)

-- 6. Keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    local keymap = vim.keymap

    opts.desc = "Show LSP references"
    keymap.set("n", "gr", function()
      Snacks.picker.lsp_references()
    end, opts)

    opts.desc = "Go to declaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

    opts.desc = "Go to definition"
    keymap.set("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, opts)

    opts.desc = "Go to implementation"
    keymap.set("n", "gi", function()
      Snacks.picker.lsp_implementations()
    end, opts)

    opts.desc = "Go to type definition"
    keymap.set("n", "gt", function()
      Snacks.picker.lsp_type_definitions()
    end, opts)

    opts.desc = "Code Actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

    opts.desc = "Rename Symbol"
    keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)

    opts.desc = "Buffer Diagnostics"
    keymap.set("n", "<leader>D", function()
      Snacks.picker.diagnostics()
    end, opts)

    opts.desc = "Line Diagnostics"
    keymap.set("n", "gl", vim.diagnostic.open_float, opts)

    opts.desc = "Prev Diagnostic"
    keymap.set("n", "<leader>dk", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts)

    opts.desc = "Next Diagnostic"
    keymap.set("n", "<leader>dj", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts)

    opts.desc = "Hover Docs"
    keymap.set("n", "K", vim.lsp.buf.hover, opts)
  end,
})
