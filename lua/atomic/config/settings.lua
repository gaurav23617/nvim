vim.g.loaded_matchparen = 1
vim.g.skip_loading_ftplugin = 1
vim.cmd("filetype plugin indent off")
vim.loader.enable()
vim.diagnostic.config({ visual_line = true })
vim.g.python3_host_prog = "~/.venvs/nvim/bin/python"
vim.o.sessionoptions =
  "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
