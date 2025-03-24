return {
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  { "nvzone/volt", lazy = true },

  {
    "nvzone/menu",
    lazy = true,
    keys = {
      {
        "<A-t>",
        function()
          require("menu").open("default")
          vim.cmd("redraw") -- Force UI refresh
        end,
        mode = "n",
        desc = "Open default menu",
      },
      {
        "<RightMouse>",
        function()
          require("menu.utils").delete_old_menus()
          vim.cmd([[normal! \<RightMouse>]])

          -- Get clicked buffer
          local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
          local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"
          require("menu").open(options)

          vim.cmd("redraw") -- Ensure UI refresh to prevent stuck menu
        end,
        mode = { "n", "v" },
        desc = "Open context menu",
      },
    },
  },
  {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    opts = {
      timeout = 1,
      maxkeys = 5,
      -- more opts
    },
  },
  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
  },
}
