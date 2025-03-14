return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    { "antosha417/nvim-lsp-file-operations", config = true },
    "folke/lazydev.nvim",
    "saghen/blink.cmp",
    { "jose-elias-alvarez/null-ls.nvim", config = true }, -- Ensure null-ls is configured
    { "folke/snacks.nvim", config = true }, -- Add Snacks plugin
  },
  event = { "BufReadPre", "BufNewFile" },

  opts = function()
    return {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      },
      inlay_hints = {
        enabled = true,
        exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
      },
      codelens = {
        enabled = false,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        phpactor = {
          enabled = vim.g.php_lsp == "phpactor",
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              completion = { callSnippet = "Replace" },
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        intelephense = {
          enabled = vim.g.php_lsp == "intelephense",
        },
      },
      setup = {},
    }
  end,

  config = function(_, opts)
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    -- 🔹 Setup capabilities (for Blink CMP and other features)
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local has_blink, blink = pcall(require, "blink.cmp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      has_blink and blink.get_lsp_capabilities() or {},
      opts.capabilities or {}
    )

    -- 🔹 Ensure Mason installs required LSP servers
    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(opts.servers),
      automatic_installation = true,
    })

    -- 🔹 Setup function for LSP servers
    local function setup(server)
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, opts.servers[server] or {})
      if server_opts.enabled == false then
        return
      end
      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup["*"] then
        if opts.setup["*"](server, server_opts) then
          return
        end
      end
      lspconfig[server].setup(server_opts)
    end

    -- 🔹 Install servers via Mason if available
    local have_mason, mlsp = pcall(require, "mason-lspconfig")
    local all_mslp_servers = {}
    if have_mason then
      all_mslp_servers =
        vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
    end

    local ensure_installed = {} ---@type string[]
    for server, server_opts in pairs(opts.servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        if server_opts.enabled ~= false then
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end
    end

    if have_mason then
      mlsp.setup({
        ensure_installed = ensure_installed,
        handlers = { setup },
      })
    end

    -- 🔹 Setup LSP keybindings
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local keymap = vim.keymap.set
        local opts = { buffer = ev.buf, silent = true }

        local mappings = {
          { "n", "gD", vim.lsp.buf.declaration, "Go to Declaration" },
          { "n", "gd", vim.lsp.buf.definition, "Go to Definition" },
          { "n", "gr", vim.lsp.buf.references, "Find References" },
          { "n", "gI", vim.lsp.buf.implementation, "Go to Implementation" },
          { "n", "gy", vim.lsp.buf.type_definition, "Go to Type Definition" },
          { "n", "K", vim.lsp.buf.hover, "Hover Documentation" },
          { "i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help" },
          { "n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions" },
          { "n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol" },
          {
            "n",
            "<leader>cf",
            function()
              vim.lsp.buf.format({ async = true })
            end,
            "Format Document",
          },
          { "n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic" },
          { "n", "]d", vim.diagnostic.goto_next, "Next Diagnostic" },
          { "n", "<leader>d", vim.diagnostic.open_float, "Show Diagnostics" },
        }

        for _, m in ipairs(mappings) do
          keymap(m[1], m[2], m[3], vim.tbl_extend("force", opts, { desc = m[4] }))
        end

        -- 🔹 Ensure Snacks.nvim works
        local ok, snacks = pcall(require, "snacks")
        if ok then
          keymap("n", "[[", function()
            snacks.words.jump(-vim.v.count1)
          end, { desc = "Previous Reference", buffer = ev.buf })
          keymap("n", "]]", function()
            snacks.words.jump(vim.v.count1)
          end, { desc = "Next Reference", buffer = ev.buf })
          keymap("n", "<A-p>", function()
            snacks.words.jump(-vim.v.count1, true)
          end, { desc = "Previous Highlighted Reference", buffer = ev.buf })
          keymap("n", "<A-n>", function()
            snacks.words.jump(vim.v.count1, true)
          end, { desc = "Next Highlighted Reference", buffer = ev.buf })
        end
      end,
    })
  end,
}
