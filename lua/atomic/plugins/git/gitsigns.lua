return {
  "lewis6991/gitsigns.nvim",
  event = { "LazyFile" },
  opts = {

    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = true, -- toggle with `:gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 500,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "next hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "prev hunk")
        map("n", "]h", function() gs.nav_hunk("last") end, "last hunk")
        map("n", "[h", function() gs.nav_hunk("first") end, "first hunk")
        map({ "n", "v" }, "<leader>ghs", ":gitsigns stage_hunk<cr>", "stage hunk")
        map({ "n", "v" }, "<leader>ghr", ":gitsigns reset_hunk<cr>", "reset hunk")
        map("n", "<leader>ghs", gs.stage_buffer, "stage buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "undo stage hunk")
        map("n", "<leader>ghr", gs.reset_buffer, "reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "preview hunk inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "blame line")
        map("n", "<leader>ghb", function() gs.blame() end, "blame buffer")
        map("n", "<leader>ghd", gs.diffthis, "diff this")
        map("n", "<leader>ghd", function() gs.diffthis("~") end, "diff this ~")
        map({ "o", "x" }, "ih", ":<c-u>gitsigns select_hunk<cr>", "gitsigns select hunk")
    end,
  },
}
