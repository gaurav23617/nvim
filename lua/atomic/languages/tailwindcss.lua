return {
  recommended = function()
    return {
      root = {
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "postcss.config.js",
        "postcss.config.cjs",
        "postcss.config.mjs",
        "postcss.config.ts",
      },
    }
  end,
  -- TailwindCSS LSP Setup
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.tailwindcss = {
        filetypes_exclude = { "markdown" }, -- Exclude markdown
        filetypes_include = {}, -- Additional filetypes can be added here
        settings = {
          tailwindCSS = {
            includeLanguages = {
              elixir = "html-eex",
              eelixir = "html-eex",
              heex = "html-eex",
            },
          },
        },
      }
    end,
  },

  -- Mason Installers for TailwindCSS
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "tailwindcss-language-server",
      })
    end,
  },
}
