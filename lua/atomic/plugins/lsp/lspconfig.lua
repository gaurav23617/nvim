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
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local function setup_lsp(server)
      lspconfig[server].setup({
        capabilities = capabilities,
      })
    end

    -- Attach LSP keymaps when LSP starts
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- Standard LSP keymaps
        keymap.set(
          "n",
          "gR",
          "<cmd>Telescope lsp_references<CR>",
          { desc = "Show LSP references", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "gD",
          vim.lsp.buf.declaration,
          { desc = "Go to declaration", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "gd",
          "<cmd>Telescope lsp_definitions<CR>",
          { desc = "Show LSP definitions", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "gi",
          "<cmd>Telescope lsp_implementations<CR>",
          { desc = "Show LSP implementations", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "gt",
          "<cmd>Telescope lsp_type_definitions<CR>",
          { desc = "Show LSP type definitions", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "<leader>ca",
          vim.lsp.buf.code_action,
          { desc = "See available code actions", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "<leader>rn",
          vim.lsp.buf.rename,
          { desc = "Smart rename", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "<leader>D",
          "<cmd>Telescope diagnostics bufnr=0<CR>",
          { desc = "Show buffer diagnostics", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "<leader>d",
          vim.diagnostic.open_float,
          { desc = "Show line diagnostics", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "[d",
          vim.diagnostic.goto_prev,
          { desc = "Go to previous diagnostic", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "]d",
          vim.diagnostic.goto_next,
          { desc = "Go to next diagnostic", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "K",
          vim.lsp.buf.hover,
          { desc = "Show documentation for what is under cursor", buffer = ev.buf }
        )
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP", buffer = ev.buf })

        keymap.set(
          "n",
          "<C-k>",
          vim.lsp.buf.signature_help,
          { desc = "Signature Help", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "<leader>wa",
          vim.lsp.buf.add_workspace_folder,
          { desc = "Add workspace folder", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "<leader>wr",
          vim.lsp.buf.remove_workspace_folder,
          { desc = "Remove workspace folder", buffer = ev.buf }
        )
        keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { desc = "List workspace folders", buffer = ev.buf })

        -- Format buffer
        keymap.set("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, { desc = "Format Document", buffer = ev.buf })

        -- Find workspace symbols
        keymap.set(
          "n",
          "<leader>ws",
          "<cmd>Telescope lsp_workspace_symbols<CR>",
          { desc = "Find workspace symbols", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "<leader>ds",
          "<cmd>Telescope lsp_document_symbols<CR>",
          { desc = "Find document symbols", buffer = ev.buf }
        )
      end,
    })

    -- Setup Mason and LSP handlers
    mason_lspconfig.setup_handlers({
      function(server_name)
        setup_lsp(server_name)
      end,
      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              completion = { callSnippet = "Replace" },
            },
          },
        })
      end,
    })
  end,
}
