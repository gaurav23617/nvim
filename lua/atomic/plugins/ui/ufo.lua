return {
  "kevinhwang91/nvim-ufo",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "kevinhwang91/promise-async" },
  config = function()
    local ufo = require("ufo")

    -- Key mappings
    vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Fold less" })
    vim.keymap.set("n", "zm", ufo.closeFoldsWith, { desc = "Fold more" })
    vim.keymap.set("n", "zp", ufo.peekFoldedLinesUnderCursor, { desc = "Peek fold" })

    -- Ensure LSP supports folding
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    require("mason-lspconfig").setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
        })
      end,
    })

    -- Configure ufo
    ufo.setup({
      preview = {
        mappings = {
          scrollB = "<C-B>",
          scrollF = "<C-F>",
          scrollU = "<C-U>",
          scrollD = "<C-D>",
        },
      },
      provider_selector = function(_, filetype, buftype)
        local function handleFallbackException(bufnr, err, providerName)
          if type(err) == "string" and err:match("UfoFallbackException") then
            return ufo.getFolds(bufnr, providerName)
          else
            return require("promise").reject(err)
          end
        end

        return (filetype == "" or buftype == "nofile") and "indent"
          or function(bufnr)
            return ufo
              .getFolds(bufnr, "lsp")
              :catch(function(err)
                return handleFallbackException(bufnr, err, "treesitter")
              end)
              :catch(function(err)
                return handleFallbackException(bufnr, err, "indent")
              end)
          end
      end,
    })
  end,
}
