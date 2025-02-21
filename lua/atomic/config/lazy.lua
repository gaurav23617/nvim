-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = { -- import your plugins
    {
      {
        import = "atomic.plugins",
      },
      {
        import = "atomic.plugins.lsp",
      },
      {
        import = "atomic.plugins.git",
      },
      {
        import = "atomic.plugins.ui",
      },
      {
        import = "atomic.plugins.ui.snacks",
      },
      {
        import = "atomic.plugins.utils",
      },
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  install = {
    colorscheme = { "catppuccin" },
  },
  -- automatically check for plugin updates
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
})
