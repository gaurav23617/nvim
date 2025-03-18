return {
  {
    -- Mini.pairs: Automatically close brackets, quotes, and more
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      LazyVim.mini.pairs(opts)
    end,
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    event = "InsertEnter",
    opts = {
      mappings = {
        add = "sra", -- Add surrounding in Normal and Visual modes
        delete = "srd", -- Delete surrounding
        find = "srf", -- Find surrounding (to the right)
        find_left = "srF", -- Find surrounding (to the left)
        highlight = "srh", -- Highlight surrounding
        replace = "srr", -- Replace surrounding
        update_n_lines = "srn", -- Update `n_lines`
      },
      keys = {
        { "sr", "", desc = "+surround" },
      },
    },
  },
  {
    -- Rainbow Delimiters: Colorize brackets and delimiters
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"], -- Use global highlighting
          vim = rainbow_delimiters.strategy["local"], -- Enable per-filetype if needed
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
  {
    -- Treesitter-endwise: Auto close `if`, `do`, `function`, etc.
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
    config = function() end,
  },
}
