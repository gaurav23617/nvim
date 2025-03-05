local function keymap(mode, keys, action, desc)
  local opts = { noremap = true, silent = true, desc = desc or "" }

  vim.keymap.set(mode, keys, action, opts)
end

-- Insert mode shortcuts
keymap("i", "jj", "<ESC>", "Exit insert mode with jj")
keymap("i", "jk", "<ESC>:w<CR>", "Exit insert mode and save file with jk")
keymap("i", "<C-d>", "<ESC>:t.<CR>i", "Copy line down in insert mode")

-- Save File
keymap("n", "<leader>w", "<ESC>:w<CR>", "Save file")
keymap("n", "<leader>ss", ":w<CR>", "Save file")
keymap("n", "<leader>wq", "<ESC>:wq<CR>", "Save and exit file")
keymap("n", "<leader>wqa", "<ESC>:wqa<CR>", "Save file and exit nvim")

keymap("n", "<leader>q", "<ESC>:q<CR>", "Exit file")

-- Clear search highlighting
keymap("n", "<Esc>", ":nohlsearch<CR>", "Clear search highlighting")
keymap("n", "<leader>nh", ":nohl<CR>", "Clear search highlights")

-- Move to window using <Ctrl> + hjkl
keymap("n", "<C-h>", "<C-w>h", "Go to Left Window")
keymap("n", "<C-j>", "<C-w>j", "Go to Lower Window")
keymap("n", "<C-k>", "<C-w>k", "Go to Upper Window")
keymap("n", "<C-l>", "<C-w>l", "Go to Right Window")

-- Resize windows using <Ctrl> + arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", "Increase Window Height")
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", "Decrease Window Height")
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", "Decrease Window Width")
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", "Increase Window Width")

-- Increment/decrement numbers
keymap("n", "<leader>+", "<C-a>", "Increment number")
keymap("n", "<leader>-", "<C-x>", "Decrement number")

-- Window management
keymap("n", "<leader>sv", "<C-w>v", "Split window vertically")
keymap("n", "<leader>sh", "<C-w>s", "Split window horizontally")
keymap("n", "<leader>se", "<C-w>=", "Make splits equal size")
keymap("n", "<leader>sx", "<cmd>close<CR>", "Close current split")

-- Tab management
keymap("n", "<leader>to", "<cmd>tabnew<CR>", "Open new tab")
keymap("n", "<leader>tx", "<cmd>tabclose<CR>", "Close current tab")
keymap("n", "<leader>tn", "<cmd>tabn<CR>", "Go to next tab")
keymap("n", "<leader>tp", "<cmd>tabp<CR>", "Go to previous tab")
keymap("n", "<leader>tf", "<cmd>tabnew %<CR>", "Open current buffer in new tab")

keymap("n", "<leader>pl", "<cmd>Lazy<CR>", "Lazy")
keymap("n", "<leader>pi", "<cmd>Lazy install<CR>", "Lazy install")
keymap("n", "<leader>pu", "<cmd>Lazy update<CR>", "Lazy update")
keymap("n", "<leader>pm", "<cmd>Mason<CR>", "Mason")
keymap("n", "<leader>pmu", "<cmd>MasonUpdate<CR>", "Mason update")
