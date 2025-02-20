return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim" },
  config = function()
    local nls = require("null-ls")

    require("null-ls").setup({
      sources = {
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.prettier,
        nls.builtins.formatting.shfmt,
        nls.builtins.diagnostics.eslint_d,
      },
    })
  end,
}
