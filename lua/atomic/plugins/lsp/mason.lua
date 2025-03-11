return {
  "williamboman/mason.nvim",
  event = "VeryLazy", -- Ensures Mason loads early
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  opts_extend = { "ensure_installed" },
  opts = {
    ensure_installed = {
      "biome",
      "eslint-lsp",
      "html-lsp",
      "css-lsp",
      "tailwindcss-language-server",
      "lua-language-server",
      "graphql-language-service-cli",
      "emmet-ls",
      "prisma-language-server",
      "pyright",
      "json-lsp",
      "stylua",
      "shfmt",
      "prettier",
      "eslint_d",
    },
  },
  ---@param opts MasonSettings | {ensure_installed: string[]}
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")

    -- Ensure all required tools are installed
    local function install_missing_tools()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end

    -- Trigger FileType event after a package is installed
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)

    -- Wait for registry refresh before installing packages
    if mr.refresh then
      mr.refresh(install_missing_tools)
    else
      install_missing_tools()
    end
  end,
}
