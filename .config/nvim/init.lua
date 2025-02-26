-- vim settings

vim.cmd([[syntax on]]) -- enable syntax highlighting

vim.g.mapleader = " " -- set leader key to space

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

-- self-explanatory settings
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
vim.opt.shortmess:append("c")

-- show whitespace, tabs, line break, etc.
vim.opt.list = true
-- note that tab is in here twice. Pretty sure that means that the second one is the one that actually gets used
-- leaving it in until that much is confirmed
vim.opt.listchars = { trail = "•", extends = "❯", precedes = "❮", tab = "▷▷⋮" }
vim.opt.showbreak = "↪ "

-- searching settings
vim.opt.showmatch = true
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
vim.opt.clipboard = {"unnamed", "unnamedplus"}

vim.diagnostic.config({
  severity_sort = true,
  virtual_lines = true,
  virtual_text = false,
})

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

-- misc
vim.opt.nrformats:append("alpha")
vim.o.formatoptions = "cro/qn1jp"

-- neovide settings
if vim.g.neovide then
  vim.g.neovide_scale_factor = 0.5
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_transparency = 0.8
  vim.g.neovide_cursor_vfx_mode = "torpedo"
end

-- plugins
require("plugins")

require("utils")
require("binds")

require("server").start("~/.local/state/nvim/nvimsocket")

-- enable dbc syntax highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.dbc" },
  command = "set filetype=dbc",
})

-- use cpp comment style in c files and cpp files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "cpp", "c" },
  command = [[set commentstring=//\ %s]],
})

-- settings for lua
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "lua" },
  command = [[set tabstop=2]],
})

-- settings for verilog
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "verilog" },
  command = [[set tabstop=2]],
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "ZIP_BUILD" },
  command = [[set ft=python]],
})
