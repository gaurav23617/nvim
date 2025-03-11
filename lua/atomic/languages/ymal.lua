return {
  recommended = function()
    return require("languages").wants({
      ft = "yaml",
      root = { "*.yaml", "*.yml" },
    })
  end,

  -- YAML Schema Support
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- Last release is outdated, so using the latest version
  },

  -- YAML LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.yamlls = {
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
        -- Lazy-load SchemaStore when needed
        on_new_config = function(new_config)
          local ok, schemastore = pcall(require, "schemastore")
          if ok then
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              schemastore.yaml.schemas()
            )
          end
        end,
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            keyOrdering = false,
            format = { enable = true },
            validate = true,
            schemaStore = {
              enable = false, -- Disable built-in schemaStore to use SchemaStore.nvim
              url = "", -- Prevent errors related to undefined length
            },
          },
        },
      }
    end,
  },

  -- Ensure Mason installs YAML LSP
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "yaml-language-server" })
    end,
  },

  -- YAML Formatting & Linting
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.yamlfmt)
      table.insert(opts.sources, nls.builtins.diagnostics.yamllint)
    end,
  },
}
