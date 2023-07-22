-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Default vim storage
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Better visual searching
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Enable rgb colours
vim.opt.termguicolors = true

-- Timeouts
vim.opt.updatetime = 50
vim.opt.timeoutlen = 2000

-- Visual indicators
vim.opt.colorcolumn = "80"



