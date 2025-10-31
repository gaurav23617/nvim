-- "Smart" Mason verification utility
local M = {}

local home = os.getenv("HOME")
local nix_profile_path = home .. "/.nix-profile/bin"
local is_nix_system = vim.fn.isdirectory(nix_profile_path) == 1

function M.get_tool_path(tool_name)
  return vim.fn.exepath(tool_name)
end

-- Check all tools and report which are Mason-managed or Nix-managed
function M.verify_tools()
  -- Debug: Show current PATH
  print("Current Neovim PATH (first 5 entries):")
  local path_entries = vim.split(vim.env.PATH, ":")
  for i = 1, math.min(5, #path_entries) do
    local marker = "  "
    if string.find(path_entries[i], "mason") then
      marker = "🔧"
    elseif string.find(path_entries[i], "nix") then
      marker = "❄️ "
    end
    print(string.format("%s %d: %s", marker, i, path_entries[i]))
  end
  print("")

  if is_nix_system then
    print("❄️  Nix environment detected. Tools should come from Nix.")
  else
    print("🔧 No Nix environment. Tools should come from Mason.")
  end

  -- List of *all* tools, regardless of source
  local all_tools = {
    -- LSPs
    "gopls",
    "lua-language-server",
    "rust-analyzer",
    "typescript-language-server",
    "intelephense",
    "zls",
    "biome",
    "nixd", -- Nix-specific LSP
    "tailwindcss-language-server",
    "html-lsp",
    "css-lsp",
    "vue-language-server",
    "tflint",

    -- Formatters
    "stylua",
    "prettier",
    "goimports",
    "black",
    "isort",
    "shfmt",
    "blade-formatter",
    "pint",
    "nixfmt-rfc-style", -- Nix-specific formatter

    -- Linters
    "golangci-lint",
    "eslint_d",
    "luacheck",
    "shellcheck",

    -- System Tools (dependencies)
    "gofmt",
    "rustfmt",
    "cargo",
    "composer",
    "luarocks",
  }

  print(
    "═══════════════════════════════════"
  )
  print("         TOOL VERIFICATION          ")
  print(
    "═══════════════════════════════════"
  )

  print("\n📦 TOOLS & DEPENDENCIES:")
  local nix_tools_found = 0
  local mason_tools_found = 0
  local system_tools_found = 0
  local not_found_tools = 0

  for _, tool in ipairs(all_tools) do
    if vim.fn.executable(tool) == 1 then
      local path = M.get_tool_path(tool)
      local status = ""
      if string.find(path, "nix", 1, true) then
        status = "✅ NIX"
        nix_tools_found = nix_tools_found + 1
      elseif string.find(path, "mason", 1, true) then
        status = is_nix_system and "⚠️  MASON (Conflict)" or "✅ MASON"
        mason_tools_found = mason_tools_found + 1
      else
        status = "✅ SYSTEM"
        system_tools_found = system_tools_found + 1
      end
      print(string.format("%-25s %s", tool, status))
    else
      print(string.format("%-25s ❌ NOT FOUND", tool))
      not_found_tools = not_found_tools + 1
    end
  end

  print(
    "\n═══════════════════════════════════"
  )
  print(string.format("❄️  Nix Tools: %d", nix_tools_found))
  print(string.format("🔧 Mason Tools: %d", mason_tools_found))
  print(string.format("🔩 System Tools: %d", system_tools_found))
  print(string.format("❌ Not Found: %d", not_found_tools))
  print("")

  if is_nix_system and mason_tools_found > 0 then
    print("⚠️  You have tools installed by Mason that conflict with your Nix setup.")
    print("💡 Run :Mason uninstall <package> and let Nix manage it.")
  elseif not is_nix_system and not_found_tools > 0 then
    print("⚠️  Some tools are missing. Run :Mason to install them.")
  elseif is_nix_system and not_found_tools > 0 then
    print("⚠️  Some tools are missing. Add them to your Home Manager config.")
  else
    print("🎉 All tools are correctly managed!")
  end
end

-- Create commands
vim.api.nvim_create_user_command(
  "MasonVerify",
  M.verify_tools,
  { desc = "Verify Mason & Nix tool management" }
)
vim.api.nvim_create_user_command("MasonFixPath", M.fix_path, { desc = "Fix Mason PATH manually" })

return M
