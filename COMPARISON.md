# Neovim 0.10 vs 0.11 LSP Configuration Comparison

## Key Differences

### Old Way (Neovim 0.10 with nvim-lspconfig)

```lua
-- Had to manually set capabilities for every server
local capabilities = require('blink.cmp').get_lsp_capabilities()
local lspconfig = require('lspconfig')

lspconfig.ts_ls.setup({
  capabilities = capabilities,
  settings = { ... }
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = { ... }
})

-- Repeat for every server...
```

### New Way (Neovim 0.11 with vim.lsp.config)

```lua
-- Capabilities are automatically detected!
vim.lsp.config('ts_ls', {
  settings = { ... }
})

vim.lsp.config('lua_ls', {
  settings = { ... }
})

-- Enable all servers at once
vim.lsp.enable({ 'ts_ls', 'lua_ls' })
```

## Benefits of Neovim 0.11

1. **Automatic Capability Detection**: No need to manually pass capabilities to each server
2. **Simpler API**: `vim.lsp.config()` and `vim.lsp.enable()` are more intuitive
3. **Better Defaults**: Many LSP keybindings work out of the box
4. **Less Boilerplate**: Configuration is more concise
5. **Native Integration**: Better performance and reliability

## Migration Checklist

If you're migrating from 0.10 to 0.11:

- [ ] Remove manual `capabilities` passing to servers
- [ ] Replace `lspconfig[server].setup()` with `vim.lsp.config(server, config)`
- [ ] Use `vim.lsp.enable()` to activate servers
- [ ] Check if your custom keybindings conflict with new defaults (see `:help lsp-defaults`)
- [ ] Update any plugins that interact with LSP

## Backwards Compatibility

> [!WARNING]
> While nvim-lspconfig still works on Neovim 0.11, the old `.setup()` method is deprecated. Use the native `vim.lsp.config()` instead for better future compatibility.

## When to Use nvim-lspconfig

On Neovim 0.11+, you generally **don't need** nvim-lspconfig for basic LSP setup. However, you might still want it for:

- Access to server configuration documentation (`:help lspconfig-all`)
- Community-maintained server configs for obscure language servers
- Compatibility with older plugins that depend on it

## Recommended Approach for 0.11

1. Use `vim.lsp.config()` for server configuration
2. Use `vim.lsp.enable()` to activate servers
3. Keep nvim-lspconfig as a reference/dependency for server settings
4. Let blink-cmp handle capabilities automatically
