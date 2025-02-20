vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.autowrite = true -- enable auto write
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- confirm to save changes before exiting modified buffer
-- opt.cursorline = true -- enable highlighting of the current line
opt.expandtab = true -- use spaces instead of tabs

opt.foldlevel = 99
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- ignore case when searching
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- wrap lines at convenient points
opt.list = true -- show some invisible characters (tabs...)
opt.mouse = "a" -- enable mouse mode
opt.pumblend = 10 -- popup blend
opt.pumheight = 10 -- maximum number of entries in a popup
opt.scrolloff = 4 -- lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- round indent
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.shortmess:append({ w = true, i = true, c = true })
opt.showmode = false -- don't show mode since we have a statusline
opt.sidescrolloff = 8 -- columns of context
opt.signcolumn = "yes" -- always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- don't ignore case with capitals
opt.smartindent = true -- insert indents automatically
opt.spelllang = { "en" }
opt.splitkeep = "screen"
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.termguicolors = true -- true color support
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- save swap file and trigger cursorhold
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- command-line completion mode
opt.winminwidth = 5 -- minimum window width

-- UI Settings
opt.relativenumber = true
opt.number = true
opt.wrap = true

-- Tabs & Indentation
opt.tabstop = 2 -- 2 spaces for tabs
opt.autoindent = true -- copy indent from current line when starting a new one

-- Search Settings
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- Colorscheme Settings
opt.background = "dark" -- colorschemes that can be light or dark will be made dark

-- Backspace Behavior
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line, or insert mode start position

-- Clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- Split Windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- Disable Swapfile
opt.swapfile = false
