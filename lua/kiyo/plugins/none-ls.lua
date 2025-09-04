return {
  "nvimtools/none-ls.nvim",
  enabled = false,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim" },
  config = function()
    local nls = require("null-ls")
    local utils = require("null-ls.utils")

    -- Register formatting similar to LazyVim
    local function format(buf)
      vim.lsp.buf.format({
        bufnr = buf,
        filter = function(client)
          return client.name == "null-ls"
        end,
      })
    end

    -- Get available sources for formatting
    local function get_sources(buf)
      local ret = require("null-ls.sources").get_available(
        vim.bo[buf].filetype,
        "NULL_LS_FORMATTING"
      ) or {}
      return vim.tbl_map(function(source)
        return source.name
      end, ret)
    end

    -- Setup null-ls
    nls.setup({
      root_dir = utils.root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
      sources = {
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.prettier,
        nls.builtins.formatting.shfmt,
        nls.builtins.diagnostics.eslint_d,
        nls.builtins.formatting.phpcsfixer, -- Added phpcsfixer
        nls.builtins.diagnostics.phpcs, -- Added phpcs
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              format(bufnr)
            end,
          })
        end
      end,
    })
  end,
}
