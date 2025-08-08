return {
  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },
  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },

  -- Render Markdown Inline
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
      checkbox = {
        enabled = false,
      },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    config = function(_, opts)
      require("render-markdown")
        .setup(opts)
        -- require("languages")
        .toggle({
          name = "Render Markdown",
          get = function()
            return require("render-markdown.state").enabled
          end,
          set = function(enabled)
            local m = require("render-markdown")
            if enabled then
              m.enable()
            else
              m.disable()
            end
          end,
        })
        :map("<leader>um")
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  -- search/replace in multiple files
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "mbbill/undotree",
    vim.keymap.set("n", "<leader><F5>", vim.cmd.UndotreeToggle),
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle),
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
  },
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "szw/vim-maximizer",
    opts = {},
    keys = {
      { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
    },
  },
  {
    "brianhuster/live-preview.nvim",
    cmd = "LivePreview",
    opts = {
      port = 5500,
      browser = "default",
      dynamic_root = false,
      sync_scroll = false,
      picker = "",
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Open DiffView for git" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close DiffView for git" },
    },
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    opts = {},
    keys = {
      { "<leader>gnn", "<cmd>Neogit<cr>", desc = "Neogit (Root Dir)" },
      { "<leader>gnc", "<cmd>Neogit commit<cr>", desc = "Commit" },
      { "<leader>gnp", "<cmd>Neogit pull<cr>", desc = "Pull" },
      { "<leader>gnP", "<cmd>Neogit push<cr>", desc = "Push" },
      { "<leader>gnf", "<cmd>Neogit fetch<cr>", desc = "Fetch" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>gn", group = "neogit", icon = " " },
      },
    },
  },
  -- Neovim plugin to improve the default vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    config = function()
      require("dressing").setup()
    end,
  },

  -- Neovim notifications and LSP progress messages
  {
    "j-hui/fidget.nvim",
  },

  -- find and replace
  {
    "windwp/nvim-spectre",
    enabled = true,
    event = "BufRead",
    keys = {
      {
        "<leader>Rr",
        function()
          require("spectre").open()
        end,
        desc = "Replace",
      },
      {
        "<leader>Rw",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        desc = "Replace Word",
      },
      {
        "<leader>Rf",
        function()
          require("spectre").open_file_search()
        end,
        desc = "Replace Buffer",
      },
    },
  },

  -- Heuristically set buffer options
  {
    "tpope/vim-sleuth",
  },
  -- editor config support
  {
    "editorconfig/editorconfig-vim",
  },

  -- persist sessions
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
  },
}
