return {
  {
    -- Mini.pairs: Automatically close brackets, quotes, and more
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    config = function()
      require("mini.pairs").setup({
        modes = { insert = true, command = false, terminal = false },

        mappings = {
          ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
          ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
          ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

          [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
          ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
          ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

          ['"'] = {
            action = "closeopen",
            pair = '""',
            neigh_pattern = "[^\\].",
            register = { cr = false },
          },
          ["'"] = {
            action = "closeopen",
            pair = "''",
            neigh_pattern = "[^%a\\].",
            register = { cr = false },
          },
          ["`"] = {
            action = "closeopen",
            pair = "``",
            neigh_pattern = "[^\\].",
            register = { cr = false },
          },
        },
      })
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
