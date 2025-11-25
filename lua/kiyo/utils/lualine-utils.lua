-- lua/kiyo/utils/lualine-utils.lua
local M = {}

-- Color configuration
M.colors = {
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

-- Get mode color
function M.get_mode_color()
  local mode_color = {
    n = M.colors.blue,
    i = M.colors.green,
    v = M.colors.mauve,
    [""] = M.colors.red,
    V = M.colors.yellow,
    c = M.colors.peach,
    no = M.colors.blue,
    s = M.colors.teal,
    S = M.colors.teal,
    [""] = M.colors.teal,
    ic = M.colors.green,
    R = M.colors.red,
    Rv = M.colors.red,
    cv = M.colors.peach,
    ce = M.colors.peach,
    r = M.colors.red,
    rm = M.colors.sky,
    ["r?"] = M.colors.sky,
    ["!"] = M.colors.flamingo,
    t = M.colors.lavender,
  }
  return { fg = mode_color[vim.fn.mode()] or M.colors.text, bg = "none", gui = "bold" }
end

-- Separator component
function M.separator()
  return {
    function()
      return "│"
    end,
    color = { fg = M.colors.surface0, bg = "NONE", gui = "bold" },
    padding = { left = 1, right = 1 },
  }
end

-- Root directory component
function M.root_dir()
  return {
    function()
      local cwd = vim.fn.getcwd()
      return "󱉭 " .. vim.fn.fnamemodify(cwd, ":t")
    end,
    color = { fg = "#16bc40" },
  }
end

-- Pretty path component
function M.pretty_path()
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

-- Macro recording component
function M.macro_recording()
  local recording_register = vim.fn.reg_recording()
  return recording_register ~= "" and ("Recording @" .. recording_register) or ""
end

-- Lazy updates component
function M.lazy_updates()
  local ok, lazy_status = pcall(require, "lazy.status")
  return ok and lazy_status.updates() or ""
end

-- Check if lazy has updates
function M.lazy_has_updates()
  local ok, lazy_status = pcall(require, "lazy.status")
  return ok and lazy_status.has_updates()
end

-- Get active LSP clients for current buffer
function M.get_lsp_clients()
  local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
  local exclude_list = { "null-ls", "copilot", "GitHub Copilot" }
  local clients = {}

  for _, client in pairs(buf_clients) do
    local should_exclude = false
    for _, excluded in ipairs(exclude_list) do
      if client.name:lower():find(excluded:lower()) then
        should_exclude = true
        break
      end
    end

    if not should_exclude then
      table.insert(clients, client.name)
    end
  end

  return clients
end

-- Get active linters for current buffer
function M.get_linters()
  local buf_ft = vim.bo.filetype
  local lint_ok, lint = pcall(require, "lint")

  if not lint_ok or not lint.linters_by_ft then
    return {}
  end

  local configured_linters = lint.linters_by_ft[buf_ft]
  if not configured_linters then
    return {}
  end

  -- Handle function-based linter configuration
  if type(configured_linters) == "function" then
    local ok, result = pcall(configured_linters)
    if ok and result then
      configured_linters = result
    else
      return {}
    end
  end

  -- Normalize to table
  if type(configured_linters) == "string" then
    return { configured_linters }
  elseif type(configured_linters) == "table" then
    return configured_linters
  end

  return {}
end

-- Get active formatters for current buffer
function M.get_formatters()
  local buf_ft = vim.bo.filetype
  local conform_ok, conform = pcall(require, "conform")

  if not conform_ok or not conform.formatters_by_ft then
    return {}
  end

  local configured_formatters = conform.formatters_by_ft[buf_ft]
  if not configured_formatters then
    return {}
  end

  -- Handle function-based formatter configuration
  if type(configured_formatters) == "function" then
    local ok, result = pcall(configured_formatters)
    if ok and result then
      configured_formatters = result
    else
      return {}
    end
  end

  -- Normalize to table and extract formatter names
  local formatters = {}
  if type(configured_formatters) == "table" then
    for _, formatter in ipairs(configured_formatters) do
      if type(formatter) == "string" then
        -- Clean up formatter names (remove _for_project suffix)
        local clean_name = formatter:gsub("_for_project$", "")
        table.insert(formatters, clean_name)
      end
    end
  end

  return formatters
end

-- Build the complete LSP status string
function M.build_lsp_status()
  local lsp_clients = M.get_lsp_clients()
  local linters = M.get_linters()
  local formatters = M.get_formatters()

  local parts = {}

  -- LSP Clients
  if #lsp_clients > 0 then
    table.insert(parts, "%#LualineLspColor#󰒋 " .. table.concat(lsp_clients, ", "))
  end

  -- Formatters
  if #formatters > 0 then
    table.insert(parts, "%#LualineFormatterColor#󰉿 " .. table.concat(formatters, ", "))
  end

  -- Linters
  if #linters > 0 then
    table.insert(parts, "%#LualineLinterColor#󰁨 " .. table.concat(linters, ", "))
  end

  -- Return appropriate message
  if #parts == 0 then
    return "%#LualineLspColor#󰒋 No servers"
  end

  return table.concat(parts, " ")
end

-- Diagnostics color function for errors
function M.diagnostic_color_error()
  local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  return { fg = (count == 0) and M.colors.green or M.colors.red, bg = "none", gui = "bold" }
end

-- Diagnostics color function for warnings
function M.diagnostic_color_warn()
  local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  return { fg = (count == 0) and M.colors.green or M.colors.yellow, bg = "none", gui = "bold" }
end

-- Diagnostics color function for info
function M.diagnostic_color_info()
  local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  return { fg = (count == 0) and M.colors.green or M.colors.blue, bg = "none", gui = "bold" }
end

-- Diagnostics color function for hints
function M.diagnostic_color_hint()
  local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  return { fg = (count == 0) and M.colors.green or M.colors.teal, bg = "none", gui = "bold" }
end

-- Setup highlight groups
function M.setup_highlights()
  vim.api.nvim_set_hl(0, "LualineLspColor", { fg = M.colors.blue, bg = "NONE", bold = true })
  vim.api.nvim_set_hl(0, "LualineFormatterColor", { fg = M.colors.peach, bg = "NONE", bold = true })
  vim.api.nvim_set_hl(0, "LualineLinterColor", { fg = M.colors.yellow, bg = "NONE", bold = true })
end

-- Configure theme to remove backgrounds
function M.configure_theme(theme)
  local modes = { "normal", "insert", "visual", "replace", "command", "inactive", "terminal" }
  for _, mode in ipairs(modes) do
    if theme[mode] and theme[mode].c then
      theme[mode].c.bg = "NONE"
    end
  end
  return theme
end
