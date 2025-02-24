return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "folke/neoconf.nvim",
      cmd = "Neoconf",
      opts = {},
    },
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

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true, desc = "LSP Keybindings" }

        keymap.set(
          "n",
          "gD",
          vim.lsp.buf.declaration,
          { desc = "Go to Declaration", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "gd",
          vim.lsp.buf.definition,
          { desc = "Go to Definition", buffer = ev.buf }
        )
        keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References", buffer = ev.buf })
        keymap.set(
          "n",
          "gI",
          vim.lsp.buf.implementation,
          { desc = "Go to Implementation", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "gy",
          vim.lsp.buf.type_definition,
          { desc = "Go to Type Definition", buffer = ev.buf }
        )
        keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation", buffer = ev.buf })
        keymap.set(
          "i",
          "<C-k>",
          vim.lsp.buf.signature_help,
          { desc = "Signature Help", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "<leader>ca",
          vim.lsp.buf.code_action,
          { desc = "Code Actions", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "<leader>cr",
          vim.lsp.buf.rename,
          { desc = "Rename Symbol", buffer = ev.buf }
        )
        keymap.set("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, { desc = "Format Document", buffer = ev.buf })
        keymap.set(
          "n",
          "[d",
          vim.diagnostic.goto_prev,
          { desc = "Previous Diagnostic", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "]d",
          vim.diagnostic.goto_next,
          { desc = "Next Diagnostic", buffer = ev.buf }
        )
        keymap.set(
          "n",
          "<leader>d",
          vim.diagnostic.open_float,
          { desc = "Show Diagnostics", buffer = ev.buf }
        )

        keymap.set("n", "[[", function()
          Snacks.words.jump(-vim.v.count1)
        end, { desc = "Previous Reference", buffer = ev.buf })
        keymap.set("n", "]]", function()
          Snacks.words.jump(vim.v.count1)
        end, { desc = "Next Reference", buffer = ev.buf })
        keymap.set("n", "<a-p>", function()
          Snacks.words.jump(-vim.v.count1, true)
        end, { desc = "Previous Highlighted Reference", buffer = ev.buf })
        keymap.set("n", "<a-n>", function()
          Snacks.words.jump(vim.v.count1, true)
        end, { desc = "Next Highlighted Reference", buffer = ev.buf })
      end,
    })

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
