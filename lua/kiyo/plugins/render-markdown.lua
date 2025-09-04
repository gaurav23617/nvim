return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ---@module 'render-markdown'
    ft = { "markdown", "norg", "rmd", "org" },
    opts = {
      -- Enable rendering in all modes
      render_modes = { "n", "c", "t" }, -- normal, command, terminal (exclude visual 'v' and insert 'i')

      heading = {
        enabled = true,
        sign = true,
        width = "full",
        -- Heading icons
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        -- Background highlight groups
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        -- Foreground highlight groups
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- Set up highlight groups with white text and default backgrounds
      vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { fg = "#ffffff" })

      vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { fg = "#ffffff" })

      vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { fg = "#ffffff" })

      vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { fg = "#ffffff" })

      vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { fg = "#ffffff" })

      vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { fg = "#ffffff" })

      -- Try to increase font size for GUI Neovim clients
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "norg", "rmd", "org" },
        callback = function()
          -- For GUI clients that support font sizing
          if vim.g.neovide then
            -- Neovide specific font scaling
            vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { fg = "#ffffff", bold = true })
            vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { fg = "#ffffff", bold = true })
            vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { fg = "#ffffff", bold = true })
          end
        end,
      })
    end,
  },
}
