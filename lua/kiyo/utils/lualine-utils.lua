-- lua/kiyo/utils/lualine-utils.lua
local M = {}

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
    -- Call the function to get actual linters
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
    -- Call the function to get actual formatters
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
        table.insert(formatters, formatter)
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

return M
