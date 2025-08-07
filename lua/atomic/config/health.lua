local M = {}

local health = vim.health or require("health")

local start = health.start or health.report_start
local ok = health.ok or health.report_ok
local warn = health.warn or health.report_warn

function M.check()
  start("System Health Check")

  -- List of essential CLI tools
  local commands = {
    "git",
    "rg", -- ripgrep
    { "fd", "fdfind" }, -- Some distros use 'fdfind' instead of 'fd'
    "lazygit",
    "fzf",
    "curl",
  }

  for _, cmd in ipairs(commands) do
    local cmd_name = type(cmd) == "string" and cmd or table.concat(cmd, " / ")
    local found = false

    -- Check if at least one command from the list is executable
    for _, name in ipairs(type(cmd) == "table" and cmd or { cmd }) do
      if vim.fn.executable(name) == 1 then
        cmd_name = name
        found = true
        break
      end
    end

    if found then
      ok(("✔ `%s` is installed"):format(cmd_name))
    else
      warn(("⚠ `%s` is missing. Some features may not work properly."):format(cmd_name))
    end
  end
end

return M
