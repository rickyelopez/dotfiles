vim.cmd("syntax on") -- enable syntax highlighting

vim.hl.priorities.semantic_tokens = 95

vim.g.mapleader = " " -- use space as leader
vim.g.winborder = "rounded"

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
-- vim.opt.smartindent = true

vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = vim.fn.expand("~/.vimfiles/undodir")
vim.opt.undofile = true
vim.opt.scrolloff = 5
vim.opt.termguicolors = true

-- make things more responsive
vim.opt.updatetime = 300
vim.opt.ttimeoutlen = 10

-- command window settings
vim.opt.cmdheight = 1
-- vim.opt.shortmess:append("c")

-- show whitespace, tabs, line break, etc.
vim.opt.list = true
vim.opt.listchars = { trail = "•", extends = "❯", precedes = "❮", tab = "▷▷⋮" }
vim.opt.showbreak = "↪ "

-- searching settings
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "nosplit"

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

vim.opt.clipboard = { "unnamed", "unnamedplus" }

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  virtual_lines = false,
  virtual_text = true,
})

vim.g.clipboard = "osc52"

-- misc
vim.opt.nrformats:append("alpha")
vim.o.formatoptions = "cr/qn1jp"

-- plugins
require("plugins")

require("utils").setup()
require("binds")
require("lsp")

require("server").start()
