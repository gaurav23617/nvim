vim.g.mapleader = " " -- change leader to a space
vim.g.maplocalleader = " " -- change localleader to a space
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.smartcase = true -- smart case
vim.opt.smartindent = true -- make indenting smarter again

require("kiyo.core.lazy")
