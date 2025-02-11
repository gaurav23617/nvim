return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = {
    "Neotree toggle filesystem",
    "Neotree toggle buffers",
    "Neotree toggle git_status",
  },
  dependencies = {
    "nvim-lua/plenary.nvim", -- required dependency for neo-tree
    "MunifTanjim/nui.nvim", -- UI components
    "nvim-tree/nvim-web-devicons", -- for file icons
    "saifulapm/neotree-file-nesting-config", -- add plugin as dependency for nesting rules
    {
      "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
      event = { "VeryLazy" },
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },

  config = function()
    local devicons = require("nvim-web-devicons")

    -- Fetch icons (fallback to an empty string or any symbol you prefer).
    local fs_icon = devicons.get_icon("folder", "", { default = false }) or ""
    local buf_icon = devicons.get_icon("default_icon_name", "", { default = false }) or ""
    local git_icon = devicons.get_icon("git", "", { default = true }) or ""
    -- Optional: check if Git is available
    local git_available = vim.fn.executable("git") == 1

    require("neo-tree").setup({
      nesting_rules = require("neotree-file-nesting-config").nesting_rules,
      -- Add all sources you want
      sources = {
        "filesystem",
        "buffers",
        "git_status", -- will show git changes if Git is available
      },
      enable_git_status = git_available,
      auto_clean_after_session_restore = true,
      close_if_last_window = true,

      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = fs_icon .. " Files" },
          { source = "buffers", display_name = buf_icon .. " Bufer" },
          { source = "git_status", display_name = git_icon .. " Git" },
        },
      },

      default_component_configs = {
        modified = {
          symbol = "[+]", -- remove or change if you prefer no symbol
        },
        git_status = {
          symbols = {
            added = "A",
            deleted = "D",
            modified = "M",
            renamed = "R",
            untracked = "U",
            ignored = "I",
            unstaged = "?",
            staged = "✓",
            conflict = "", -- remove or change as you wish
          },
        },
      },

      commands = {
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          -- For Neovim 0.10+:
          if vim.ui.open then
            vim.ui.open(path)
          else
            -- Fallback (Linux example). For macOS, use 'open', Windows 'start', etc.
            vim.cmd(("!xdg-open '%s'"):format(path))
          end
        end,

        parent_or_close = function(state)
          local node = state.tree:get_node()
          if node:has_children() and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,

        child_or_open = function(state)
          local node = state.tree:get_node()
          if node:has_children() then
            if not node:is_expanded() then
              state.commands.toggle_node(state)
            else
              if node.type == "file" then
                state.commands.open(state)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            end
          else
            state.commands.open(state)
          end
        end,

        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["PATH"] = filepath,
            ["URI"] = vim.uri_from_fname(filepath),
          }

          local options = {}
          for k, v in pairs(vals) do
            if v ~= "" then
              table.insert(options, k)
            end
          end
          table.sort(options)

          if #options == 0 then
            vim.notify("No values to copy", vim.log.levels.WARN)
            return
          end

          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item)
              return ("%s: %s"):format(item, vals[item])
            end,
          }, function(choice)
            if choice then
              local result = vals[choice]
              vim.notify("Copied: " .. result)
              vim.fn.setreg("+", result)
            end
          end)
        end,
      },

      window = {
        width = 28,
        position = "right",
        mapping_options = { noremap = true, nowait = true },
        mappings = {
          -- keep your existing mapping for toggling a node
          ["<space>"] = { "toggle_node", nowait = false },
          -- add some custom mappings from the commands above
          ["<S-CR>"] = "system_open",
          O = "system_open",
          Y = "copy_selector",
          h = "parent_or_close",
          l = "child_or_open",
        },
      },

      filesystem = {
        window = {
          width = 28,
          position = "right",
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
      },
      git_status = {
        enabled = true,
        symbols = { ignored = "I" }, -- minimal example
      },

      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_)
            -- Example: adjust signcolumn/foldcolumn automatically
            vim.opt_local.signcolumn = "auto"
            vim.opt_local.foldcolumn = "0"
          end,
        },
      },
    })

    -- 1) Auto open Neo-Tree when opening a directory
    vim.api.nvim_create_autocmd("BufEnter", {
      desc = "Open Neo-Tree on startup with directory",
      callback = function()
        if package.loaded["neo-tree"] then
          return
        else
          local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0))
          if stats and stats.type == "directory" then
            require("lazy").load({ plugins = { "neo-tree.nvim" } })
            vim.cmd("Neotree reveal") -- Auto-reveal files
          end
        end
      end,
    })

    -- 2) Refresh Neo-tree when closing LazyGit
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit*",
      desc = "Refresh Neo-Tree sources when closing lazygit",
      callback = function()
        local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
        if manager_avail then
          for _, source in ipairs({ "filesystem", "git_status", "document_symbols" }) do
            local module = "neo-tree.sources." .. source
            if package.loaded[module] then
              manager.refresh(require(module).name)
            end
          end
        end
      end,
    })

    --------------------------------------------------------------------------------
    -- Keymaps
    --------------------------------------------------------------------------------
    local keymap = vim.keymap

    -- Toggle each source
    keymap.set(
      "n",
      "<leader>e",
      "<cmd>Neotree toggle filesystem<CR>",
      { desc = "Toggle file explorer" }
    )
    keymap.set(
      "n",
      "<leader>eb",
      "<cmd>Neotree toggle buffers<CR>",
      { desc = "Toggle buffer explorer" }
    )
    keymap.set(
      "n",
      "<leader>eg",
      "<cmd>Neotree toggle git_status<CR>",
      { desc = "Toggle git explorer" }
    )

    keymap.set(
      "i",
      "<C-B>",
      "<cmd>Neotree toggle filesystem<CR>",
      { desc = "Toggle file explorer (Insert)" }
    )
    keymap.set(
      "n",
      "<leader>ef",
      "<cmd>Neotree reveal<CR>",
      { desc = "Reveal current file in explorer" }
    )
    keymap.set("n", "<leader>ec", "<cmd>Neotree close<CR>", { desc = "Close Neo-tree" })
    keymap.set("n", "<leader>er", "<cmd>Neotree refresh<CR>", { desc = "Refresh Neo-tree" })

    -- Toggle between Neo-tree and the last active window
    keymap.set("n", "<Leader>o", function()
      if vim.bo.filetype == "neo-tree" then
        vim.cmd.wincmd("p")
      else
        vim.cmd.Neotree("focus")
      end
    end, { desc = "Toggle Explorer Focus" })
  end,
}
