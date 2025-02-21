return {
  "akinsho/bufferline.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bd", "<cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    { "<leader>br", "<cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
    { "]b", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    { "[B", "<cmd>BufferLineMovePrev<CR>", desc = "Move buffer left" },
    { "]B", "<cmd>BufferLineMoveNext<CR>", desc = "Move buffer right" },
  },
  opts = {
    options = {
      close_command = function(n)
        vim.api.nvim_buf_delete(n, { force = true })
      end,
      right_mouse_command = function(n)
        vim.api.nvim_buf_delete(n, { force = true })
      end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      diagnostics_indicator = function(count, level, diagnostics_dict)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
          local icon = (e == "error" and " ") or (e == "warning" and " ") or " "
          s = s .. icon .. n .. " "
        end
        return s
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left",
          separator = true, -- Ensures a proper gap between Bufferline and Neo-tree
        },
      },
      get_element_icon = function(opts)
        local ok, devicons = pcall(require, "nvim-web-devicons")
        if ok then
          local icon, _ = devicons.get_icon(opts.filename, opts.extension, { default = true })
          return icon
        end
      end,
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          pcall(require("bufferline").setup)
        end)
      end,
    })
  end,
}
