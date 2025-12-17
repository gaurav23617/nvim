-- LSP Configuration for Neovim 0.11+
-- Using native vim.lsp.enable without extensive vim.lsp.config
-- Inspired by: https://github.com/smnatale/nvim

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp", -- For LSP capabilities (auto-detected in 0.11)
    },
    config = function()
      -- ========================================
      -- Diagnostic Configuration
      -- ========================================
      vim.diagnostic.config({
        -- Show inline error messages (disabled by default in 0.11)
        virtual_text = true,

        -- Show diagnostic signs in the sign column
        signs = true,

        -- Update diagnostics while typing
        update_in_insert = false,

        -- Underline diagnostics
        underline = true,

        -- Sort diagnostics by severity
        severity_sort = true,

        -- Floating window configuration
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- ========================================
      -- Diagnostic Signs
      -- ========================================
      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- ========================================
      -- Enable LSP Servers
      -- ========================================
      -- Simply enable the servers - Neovim 0.11 handles the rest!
      -- Server configs come from nvim-lspconfig defaults
      vim.lsp.enable({
        -- Web Development
        "ts_ls",                -- TypeScript/JavaScript
        "html",                 -- HTML
        "cssls",                -- CSS
        "tailwindcss",          -- TailwindCSS
        "emmet_language_server", -- Emmet
        "eslint",               -- ESLint

        -- Backend
        "lua_ls",               -- Lua
        "pyright",              -- Python
        "gopls",                -- Go
        "rust_analyzer",        -- Rust

        -- Add more as needed
      })

      -- ========================================
      -- LSP Attach Configuration
      -- ========================================
      -- Customize behavior when LSP attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }

          -- Get the client for this buffer
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- ========================================
          -- Keybindings
          -- ========================================
          -- Note: Many of these are already default in Neovim 0.11
          -- but we define them here for customization

          -- Go to definition
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

          -- Go to declaration
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

          -- Go to implementation
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

          -- Go to type definition
          vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, opts)

          -- Show references
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

          -- Hover documentation
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

          -- Signature help
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

          -- Rename symbol
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          -- Code action
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

          -- Format buffer
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)

          -- Show diagnostics in floating window
          vim.keymap.set("n", "<leader>d", function()
            vim.diagnostic.open_float({
              border = "rounded",
            })
          end, opts)

          -- Go to next/previous diagnostic
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

          -- ========================================
          -- Inlay Hints (if supported)
          -- ========================================
          if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end

          -- ========================================
          -- Document Highlight (if supported)
          -- ========================================
          -- Highlight symbol under cursor
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("LspDocumentHighlight", {})
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = ev.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = ev.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- ========================================
      -- Handlers Configuration
      -- ========================================
      -- Customize LSP floating windows
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = "rounded" }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = "rounded" }
      )
    end
  }
}
