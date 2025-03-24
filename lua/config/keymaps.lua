-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local o = vim.opt

local lazy = require("lazy")

-- Insert mode shortcuts
map("i", "<C-d>", "<ESC>:t.<CR>i", { desc = "Copy line down in insert mode" })
map("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit file" })

-- packages
map("n", "<leader>pl", "<cmd>Lazy<CR>", { desc = "Lazy" })
map("n", "<leader>px", "<cmd>LazyExtras<CR>", { desc = "Lazy Extras" })
map("n", "<leader>pi", "<cmd>Lazy install<CR>", { desc = "Lazy install" })
map("n", "<leader>pu", "<cmd>Lazy update<CR>", { desc = "Lazy update" })
map("n", "<leader>pm", "<cmd>Mason<CR>", { desc = "Mason" })
map("n", "<leader>pmu", "<cmd>MasonUpdate<CR>", { desc = "Mason update" })

-- windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>sh", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>sv", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>se", "<C-W>=", { desc = "Make splits equal size", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>sx", "<C-W>c", { desc = "Delete Window", remap = true })
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

-- save file
map("i", "jk", "<ESC>:w<CR>", { desc = "Exit insert mode and save file with jk" })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("i", "jk", "<ESC>:w<CR>", { desc = "Exit insert mode and save file with jk" })
map("n", "<leader>w", "<ESC>:w<CR>", { desc = "Save file" })
map("n", "<leader>wq", "<ESC>:wq<CR>", { desc = "Save and exit file" })
map("n", "<leader>wqa", "<ESC>:wqa<CR>", { desc = "Save file and exit nvim" })
