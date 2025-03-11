return {
  recommended = function()
    return {
      ft = "php",
      root = { "composer.json", ".phpactor.json", ".phpactor.yml" },
    }
  end,

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "php" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        phpactor = {
          enabled = vim.g.php_lsp == "phpactor",
        },
        intelephense = {
          enabled = vim.g.php_lsp == "intelephense",
        },
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "phpactor",
        "intelephense",
        "php-debug-adapter",
        "phpcs",
        "php-cs-fixer",
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      local registry = require("mason-registry")
      local package = registry.get_package("php-debug-adapter")
      if package then
        local path = package:get_install_path()
        dap.adapters.php = {
          type = "executable",
          command = "node",
          args = { path .. "/extension/out/phpDebug.js" },
        }
      end
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.phpcsfixer)
      table.insert(opts.sources, nls.builtins.diagnostics.phpcs)
    end,
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        php = { "phpcs" },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        php = { "php_cs_fixer" },
      },
    },
  },
}
