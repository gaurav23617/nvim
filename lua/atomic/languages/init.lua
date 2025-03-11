local M = {}

M.language_modules = {}

--- Checks if the current buffer or project matches the given criteria
---@param opts { ft?: string|string[], root?: string|string[] }
---@return boolean
function M.wants(opts)
  local buf = vim.api.nvim_get_current_buf()

  -- Check Filetype
  if opts.ft then
    local fts = type(opts.ft) == "string" and { opts.ft } or opts.ft
    if vim.tbl_contains(fts, vim.bo[buf].filetype) then
      return true
    end
  end

  -- Check Root Files (Project Detection)
  if opts.root then
    local roots = type(opts.root) == "string" and { opts.root } or opts.root
    local cwd = vim.fn.getcwd()

    for _, root in ipairs(roots) do
      if
        vim.fn.filereadable(cwd .. "/" .. root) == 1
        or vim.fn.isdirectory(cwd .. "/" .. root) == 1
      then
        return true
      end
    end
  end

  return false
end

--- Loads all available language modules dynamically
local function load_languages()
  local languages_path = vim.fn.stdpath("config") .. "/lua/languages/"
  local handle = vim.loop.fs_scandir(languages_path)

  if not handle then
    return
  end

  for name, _ in
    function()
      return vim.loop.fs_scandir_next(handle)
    end
  do
    if name:match("%.lua$") and name ~= "init.lua" then
      local module = "languages." .. name:gsub("%.lua$", "")
      if not vim.tbl_contains(M.language_modules, module) then
        table.insert(M.language_modules, module)
      end
    end
  end
end

--- Initializes all language modules
M.setup = function()
  if #M.language_modules == 0 then
    load_languages()
  end

  for _, module in ipairs(M.language_modules) do
    local success, mod = pcall(require, module)
    if success and type(mod.recommended) == "function" then
      if mod.recommended() then
        if type(mod.setup) == "function" then
          mod.setup()
        else
          vim.notify(
            "Module " .. module .. " does not have a `setup()` function",
            vim.log.levels.WARN
          )
        end
      end
    elseif not success then
      vim.notify(
        "Failed to load language module: " .. module .. "\nError: " .. mod,
        vim.log.levels.ERROR
      )
    end
  end
end

return M
