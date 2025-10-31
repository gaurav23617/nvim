-- FIX: Manually set the PATH for GUI-launched Neovim
-- This function reads all PATH exports from your exports.zsh
local function set_gui_path()
  local home = os.getenv("HOME")
  if not home then
    return
  end

  -- All paths from your exports.zsh
  local paths_to_prepend = {
    home .. "/.nix-profile/bin", -- Nix (for composer, luarocks, etc.)
    home .. "/.cargo/bin", -- Rust
    home .. "/.local/bin",
    home .. "/.npm-global/bin",
    home .. "/.docker/bin",
    home .. "/.local/nvim-macos-arm64/bin",
    home .. "/.local/share/go/bin",
    home .. "/.local/share/neovim/bin",
    home .. "/.local/share/pnpm", -- pnpm
    -- We also add the default system paths, just in case
    "/usr/local/bin",
    "/usr/bin",
    "/bin",
  }

  local current_path = vim.env.PATH or ""
  local new_path_entries = {}
  local seen = {}

  -- Add our new paths
  for _, path in ipairs(paths_to_prepend) do
    if not seen[path] then
      table.insert(new_path_entries, path)
      seen[path] = true
    end
  end

  -- Add old paths (de-duplicated)
  for path in string.gmatch(current_path, "([^:]+)") do
    if not seen[path] then
      table.insert(new_path_entries, path)
      seen[path] = true
    end
  end

  vim.env.PATH = table.concat(new_path_entries, ":")
end

-- Run the PATH fix *immediately*
set_gui_path()

--
-- CONFIG LOAD ORDER (FIXED)
--

-- 1. Load core settings first
require("kiyo.config.options")
require("kiyo.config.keymaps")
require("kiyo.config.autocmds")
require("kiyo.config.lsp-utils")
require("kiyo.core.mason-path")
require("kiyo.core.lazy")
require("kiyo.core.lsp")
require("kiyo.config.mason-verify")
require("kiyo.config.health-check")
