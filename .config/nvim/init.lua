-- vim settings

vim.cmd([[syntax on]]) -- enable syntax highlighting

vim.g.mapleader = " " -- set leader key to space

vim.opt.mouse = "a" -- enable mouse support
vim.opt.hidden = true -- enable buffer switching

-- disable bells
vim.opt.errorbells = false
vim.opt.visualbell = true
-- vim.opt.t_vb = ""

-- tab settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 0
vim.opt.expandtab = true
vim.opt.smarttab = true
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true

-- self-explanatory settings
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = vim.fn.expand("$HOME") .. "/.vimfiles/undodir"
vim.opt.undofile = true
vim.opt.showmatch = true
vim.opt.scrolloff = 5
vim.opt.termguicolors = true

-- make things more responsive
vim.opt.updatetime = 300
vim.opt.ttimeoutlen = 10

-- command window settings
vim.opt.cmdheight = 2
vim.opt.shortmess = vim.opt.shortmess + "c"

vim.opt.nrformats = vim.opt.nrformats + "alpha"
vim.opt.formatoptions = vim.opt.formatoptions + "j"

-- show whitespace, tabs, line break, etc.
vim.opt.list = true
vim.opt.listchars = [[tab:│\ ,trail:•,extends:❯,precedes:❮,tab:▷▷⋮]]
vim.opt.shiftround = true
vim.o.showbreak = "↪ "

-- searching settings
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.inccommand = "nosplit"

-- number column
vim.opt.number = true
vim.opt.relativenumber = true
-- vim.opt.signcolumn = "number"
-- vim.opt.signcolumn = "auto:3"
vim.opt.signcolumn = "yes"

-- color column
vim.opt.colorcolumn = "120"

-- don't fold anything when opening file
vim.opt.foldlevel = 99

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- source leftover .vim file that I don't feel like converting
vim.api.nvim_exec([[ source $HOME/.config/nvim/plug-conf/fzf.vim ]], false)

-- plugins
require("plug-conf")

require("utils")
require("binds")