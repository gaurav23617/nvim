return {
  "nvimtools/none-ls.nvim",
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

    -- Create custom biome source since none-ls doesn't have built-in biome support
    local biome_formatting = {
      method = nls.methods.FORMATTING,
      filetypes = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "json",
        "jsonc",
      },
      generator = nls.formatter({
        command = function()
          local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/biome"
          if vim.fn.executable(mason_bin) == 1 then
            return mason_bin
          end
          return "biome"
        end,
        args = { "format", "--stdin-file-path", "$FILENAME" },
        to_stdin = true,
      }),
    }

    local biome_diagnostics = {
      method = nls.methods.DIAGNOSTICS,
      filetypes = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "json",
        "jsonc",
      },
      generator = nls.generator({
        command = function()
          local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/biome"
          if vim.fn.executable(mason_bin) == 1 then
            return mason_bin
          end
          return "biome"
        end,
        args = {
          "lint",
          "--stdin-file-path",
          "$FILENAME",
          "--diagnostic-level=info",
          "--reporter=json",
        },
        to_stdin = true,
        format = "json",
        check_exit_code = function(code)
          return code <= 1
        end,
        on_output = function(params, done)
          local output = params.output
          if not output then
            return done()
          end

          local diagnostics = {}
          local ok, json = pcall(vim.json.decode, output)

          if not ok or not json or not json.diagnostics then
            return done(diagnostics)
          end

          for _, diagnostic in ipairs(json.diagnostics) do
            local severity = 1 -- Error by default

            if diagnostic.severity == "warning" then
              severity = 2
            elseif diagnostic.severity == "info" then
              severity = 3
            elseif diagnostic.severity == "hint" then
              severity = 4
            end

            local lnum = 1
            local col = 1
            local end_lnum = 1
            local end_col = 1

            if diagnostic.location and diagnostic.location.span then
              lnum = diagnostic.location.span.start and diagnostic.location.span.start.line or 1
              col = diagnostic.location.span.start and diagnostic.location.span.start.column or 1
              end_lnum = diagnostic.location.span["end"] and diagnostic.location.span["end"].line
                or lnum
              end_col = diagnostic.location.span["end"] and diagnostic.location.span["end"].column
                or col
            end

            table.insert(diagnostics, {
              row = lnum,
              col = col,
              end_row = end_lnum,
              end_col = end_col,
              message = diagnostic.description or diagnostic.message or "Biome diagnostic",
              severity = severity,
              code = diagnostic.category,
              source = "biome",
            })
          end

          done(diagnostics)
        end,
      }),
    }

    -- Setup null-ls
    nls.setup({
      root_dir = utils.root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
      sources = {
        -- Lua
        nls.builtins.formatting.stylua,

        -- General web formatting (for files biome doesn't support)
        nls.builtins.formatting.prettier.with({
          filetypes = { "html", "css", "scss", "yaml", "markdown" }, -- Exclude JS/TS files
        }),

        -- Shell
        nls.builtins.formatting.shfmt,

        -- PHP
        nls.builtins.formatting.phpcsfixer,
        nls.builtins.diagnostics.phpcs,

        -- Custom biome sources
        biome_formatting,
        biome_diagnostics,

        -- Remove eslint_d since we're using biome
        -- nls.builtins.diagnostics.eslint_d, -- REMOVED
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
