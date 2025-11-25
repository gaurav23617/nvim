-- lua/kiyo/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local auto = require("lualine.themes.auto")
    local utils = require("kiyo.utils.lualine-utils")

    -- Setup highlight groups
    utils.setup_highlights()

    -- Configure theme
    local theme = utils.configure_theme(auto)

    -- Configure options
    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
      theme = theme,
      component_separators = "",
      section_separators = "",
      globalstatus = true,
      disabled_filetypes = { statusline = {}, winbar = {} },
    })

    -- Configure sections
    opts.sections = {
      lualine_a = {
        {
          "mode",
          icon = "  ",
          color = utils.get_mode_color,
          padding = { left = 0, right = 0 },
        },
      },

      lualine_b = {
        utils.separator(),
        { "branch", color = { bg = "none" } },
        {
          "diff",
          colored = true,
          diff_color = {
            added = { fg = utils.colors.teal, bg = "none", gui = "bold" },
            modified = { fg = utils.colors.yellow, bg = "none", gui = "bold" },
            removed = { fg = utils.colors.red, bg = "none", gui = "bold" },
          },
          symbols = { added = "+", modified = "~", removed = "-" },
          padding = { left = 1, right = 0 },
        },
      },

      lualine_c = {
        utils.separator(),
        utils.root_dir(),
        { "filetype", icon_only = true, separator = "", padding = { left = 0, right = 0 } },
        { utils.pretty_path() },
      },

      lualine_x = {
        {
          utils.macro_recording,
          cond = function()
            return vim.fn.reg_recording() ~= ""
          end,
          color = { fg = "#ff0000" },
        },
        {
          function()
            return "│"
          end,
          cond = function()
            return vim.fn.reg_recording() ~= ""
          end,
          color = { fg = utils.colors.surface0, bg = "NONE", gui = "bold" },
          padding = { left = 0, right = 1 },
        },
        {
          utils.lazy_updates,
          cond = utils.lazy_has_updates,
          color = { fg = "#ff9e64" },
        },
        {
          cond = utils.lazy_has_updates,
          color = { fg = utils.colors.surface0, bg = "NONE", gui = "bold" },
          padding = { left = 1, right = 1 },
          function()
            return "│"
          end,
        },
        {
          "fileformat",
          color = { fg = utils.colors.yellow, bg = "none", gui = "bold" },
          symbols = {
            unix = "",
            dos = "",
            mac = "",
          },
          padding = { left = 0, right = 0 },
        },
        {
          "encoding",
          color = { fg = utils.colors.yellow, bg = "none", gui = "bold" },
          padding = { left = 1, right = 1 },
        },
        {
          function()
            return "│"
          end,
          color = { fg = utils.colors.surface0, bg = "NONE", gui = "bold" },
          padding = { left = 0, right = 0 },
        },
        {
          function()
            return utils.build_lsp_status()
          end,
          color = { bg = "none" },
          padding = { left = 0, right = 0 },
        },
      },

      lualine_y = {
        utils.separator(),
        {
          "diagnostics",
          sources = { "nvim_diagnostic", "coc" },
          sections = { "error", "warn", "info", "hint" },
          diagnostics_color = {
            error = utils.diagnostic_color_error,
            warn = utils.diagnostic_color_warn,
            info = utils.diagnostic_color_info,
            hint = utils.diagnostic_color_hint,
          },
          symbols = {
            error = "󰅚 ",
            warn = "󰀪 ",
            info = "󰋽 ",
            hint = "󰌶 ",
          },
          colored = true,
          update_in_insert = false,
          always_visible = true,
          padding = { left = 0, right = 0 },
        },
      },

      lualine_z = {
        utils.separator(),
        {
          "progress",
          color = { fg = utils.colors.red, bg = "none", gui = "bold" },
          padding = { left = 0, right = 0 },
        },
        {
          "location",
          color = { fg = utils.colors.red, bg = "none", gui = "bold" },
          padding = { left = 1, right = 0 },
        },
      },
    }

    return opts
  end,
}
