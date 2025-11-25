-- lua/kiyo/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local auto = require("lualine.themes.auto")
    local lualine_utils = require("kiyo.utils.lualine-utils")

    local colors = {
      rosewater = "#f2d5cf",
      flamingo = "#eebebe",
      pink = "#f4b8e4",
      mauve = "#ca9ee6",
      red = "#e78284",
      maroon = "#ea999c",
      peach = "#ef9f76",
      yellow = "#e5c890",
      green = "#a6d189",
      teal = "#81c8be",
      sky = "#99d1db",
      sapphire = "#85c1dc",
      blue = "#8caaee",
      lavender = "#babbf1",
      text = "#c6d0f5",
      subtext1 = "#b5bfe2",
      subtext0 = "#a5adce",
      overlay2 = "#949cbb",
      overlay1 = "#838ba7",
      overlay0 = "#737994",
      surface2 = "#626880",
      surface1 = "#51576d",
      surface0 = "#414559",
      base = "#303446",
      mantle = "#292c3c",
      crust = "#232634",
    }

    -- Helper functions
    local function separator()
      return {
        function()
          return "│"
        end,
        color = { fg = colors.surface0, bg = "NONE", gui = "bold" },
        padding = { left = 1, right = 1 },
      }
    end

    local function root_dir()
      return {
        function()
          local cwd = vim.fn.getcwd()
          return "󱉭 " .. vim.fn.fnamemodify(cwd, ":t")
        end,
        color = { fg = "#16bc40" },
      }
    end

    local function pretty_path()
      return function()
        local path = vim.fn.expand("%:p")
        if path == "" then
          return ""
        end

        local cwd = vim.fn.getcwd()
        if path:find(cwd, 1, true) == 1 then
          path = path:sub(#cwd + 2)
        end

        local parts = vim.split(path, "[\\/]")
        if #parts > 3 then
          parts = { parts[1], "…", unpack(parts, #parts - 2, #parts) }
        end

        return table.concat(parts, "/")
      end
    end

    local function macro_recording()
      local recording_register = vim.fn.reg_recording()
      return recording_register ~= "" and ("Recording @" .. recording_register) or ""
    end

    -- Define custom highlight groups
    vim.api.nvim_set_hl(0, "LualineLspColor", { fg = colors.blue, bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "LualineFormatterColor", { fg = colors.peach, bg = "NONE", bold = true })
    vim.api.nvim_set_hl(0, "LualineLinterColor", { fg = colors.yellow, bg = "NONE", bold = true })

    -- LSP status component using the utility
    local lsp_status = {
      function()
        return lualine_utils.build_lsp_status()
      end,
      color = { bg = "none" },
      padding = { left = 0, right = 0 },
    }

    -- Lazy updates component
    local lazy_updates = function()
      local ok, lazy_status = pcall(require, "lazy.status")
      return ok and lazy_status.updates() or ""
    end

    local lazy_has_updates = function()
      local ok, lazy_status = pcall(require, "lazy.status")
      return ok and lazy_status.has_updates()
    end

    -- Configure theme to remove backgrounds
    local modes = { "normal", "insert", "visual", "replace", "command", "inactive", "terminal" }
    for _, mode in ipairs(modes) do
      if auto[mode] and auto[mode].c then
        auto[mode].c.bg = "NONE"
      end
    end

    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
      theme = auto,
      component_separators = "",
      section_separators = "",
      globalstatus = true,
      disabled_filetypes = { statusline = {}, winbar = {} },
    })

    opts.sections = {
      lualine_a = {
        {
          "mode",
          icon = "  ",
          color = function()
            local mode_color = {
              n = colors.blue,
              i = colors.green,
              v = colors.mauve,
              [""] = colors.red,
              V = colors.yellow,
              c = colors.peach,
              no = colors.blue,
              s = colors.teal,
              S = colors.teal,
              [""] = colors.teal,
              ic = colors.green,
              R = colors.red,
              Rv = colors.red,
              cv = colors.peach,
              ce = colors.peach,
              r = colors.red,
              rm = colors.sky,
              ["r?"] = colors.sky,
              ["!"] = colors.flamingo,
              t = colors.lavender,
            }
            return { fg = mode_color[vim.fn.mode()] or colors.text, bg = "none", gui = "bold" }
          end,
          padding = { left = 0, right = 0 },
        },
      },
      lualine_b = {
        separator(),
        { "branch", color = { bg = "none" } },
        {
          "diff",
          colored = true,
          diff_color = {
            added = { fg = colors.teal, bg = "none", gui = "bold" },
            modified = { fg = colors.yellow, bg = "none", gui = "bold" },
            removed = { fg = colors.red, bg = "none", gui = "bold" },
          },
          symbols = { added = "+", modified = "~", removed = "-" },
          padding = { left = 1, right = 0 },
        },
      },
      lualine_c = {
        separator(),
        root_dir(),
        { "filetype", icon_only = true, separator = "", padding = { left = 0, right = 0 } },
        { pretty_path() },
      },
      lualine_x = {
        {
          macro_recording,
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
          color = { fg = colors.surface0, bg = "NONE", gui = "bold" },
          padding = { left = 0, right = 1 },
        },
        {
          lazy_updates,
          cond = lazy_has_updates,
          color = { fg = "#ff9e64" },
        },
        {
          cond = lazy_has_updates,
          color = { fg = colors.surface0, bg = "NONE", gui = "bold" },
          padding = { left = 1, right = 1 },
          function()
            return "│"
          end,
        },
        {
          "fileformat",
          color = { fg = colors.yellow, bg = "none", gui = "bold" },
          symbols = {
            unix = "",
            dos = "",
            mac = "",
          },
          padding = { left = 0, right = 0 },
        },
        {
          "encoding",
          color = { fg = colors.yellow, bg = "none", gui = "bold" },
          padding = { left = 1, right = 1 },
        },
        {
          function()
            return "│"
          end,
          color = { fg = colors.surface0, bg = "NONE", gui = "bold" },
          padding = { left = 0, right = 0 },
        },
        lsp_status,
      },
      lualine_y = {
        separator(),
        {
          "diagnostics",
          sources = { "nvim_diagnostic", "coc" },
          sections = { "error", "warn", "info", "hint" },
          diagnostics_color = {
            error = function()
              local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
              return { fg = (count == 0) and colors.green or colors.red, bg = "none", gui = "bold" }
            end,
            warn = function()
              local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
              return {
                fg = (count == 0) and colors.green or colors.yellow,
                bg = "none",
                gui = "bold",
              }
            end,
            info = function()
              local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
              return { fg = (count == 0) and colors.green or colors.blue, bg = "none", gui = "bold" }
            end,
            hint = function()
              local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
              return { fg = (count == 0) and colors.green or colors.teal, bg = "none", gui = "bold" }
            end,
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
        separator(),
        {
          "progress",
          color = { fg = colors.red, bg = "none", gui = "bold" },
          padding = { left = 0, right = 0 },
        },
        {
          "location",
          color = { fg = colors.red, bg = "none", gui = "bold" },
          padding = { left = 1, right = 0 },
        },
      },
    }

    return opts
  end,
}
