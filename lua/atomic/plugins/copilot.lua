return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = true,
      },
      suggestion = {
        enabled = true,
      },
      filetypes = {
        markdown = true,
        help = true,
        lua = true,
        javascript = true,
        typescript = true,
        python = true,
        css = true,
        html = true,
      },
      auto_start = true,
    },
    config = function(_, opts)
      require("copilot").setup(opts)

      -- AI Accept Action
      vim.api.nvim_create_user_command("CopilotAccept", function()
        local copilot = require("copilot.suggestion")
        if copilot.is_visible() then
          copilot.accept()
        end
      end, {})

      -- Map Copilot Accept to <M-l>
      vim.keymap.set("i", "<M-l>", function()
        local copilot = require("copilot.suggestion")
        if copilot.is_visible() then
          copilot.accept()
        end
      end, { desc = "Accept Copilot Suggestion" })
    end,
  },
}
