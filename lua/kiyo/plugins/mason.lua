return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- LSP servers (matching your vim.lsp.enable() config)
        "lua-language-server",
        "gopls",
        "zls",
        "typescript-language-server",
        "rust-analyzer",
        "intelephense",
        "tailwindcss-language-server",
        "html-lsp",
        "css-lsp",
        "vue-language-server",
        "biome",
        "nixd", -- CHANGED: Was "nil"
        "nixfmt-rfc-style", -- CHANGED: Was "nixfmt"
        "tflint",

        -- Formatters
        "stylua",
        "goimports",
        "prettier",
        "blade-formatter",

        -- Linters and diagnostics
        "golangci-lint",
        "eslint_d",
        "luacheck",
        "pint",

        -- Additional useful tools
        "delve",
        "shfmt",
        "shellcheck",
      },
    },
    config = function(_, opts)
      -- Add providers for Nix-first, Mason-fallback hybrid mode
      opts.providers = {
        "mason.providers.client", -- Checks system PATH (for Nix tools)
        "mason.providers.package", -- The default Mason installer (as a fallback)
      }

      require("mason").setup(opts)

      -- Auto-install logic (unchanged)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          if mr.has_package(tool) then
            local p = mr.get_package(tool)
            if not p:is_installed() then
              vim.notify("Mason: Installing " .. tool .. "...", vim.log.levels.INFO)
              p:install():once("closed", function()
                if p:is_installed() then
                  vim.notify("Mason: Successfully installed " .. tool, vim.log.levels.INFO)
                else
                  vim.notify("Mason: Failed to install " .. tool, vim.log.levels.ERROR)
                end
              end)
            end
          else
            vim.notify("Mason: Package '" .. tool .. "' not found", vim.log.levels.WARN)
          end
        end
      end

      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
