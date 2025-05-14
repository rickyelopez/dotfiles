vim.cmd("syntax on") -- enable syntax highlighting

vim.hl.priorities.semantic_tokens = 95

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

-- clipboard
vim.opt.clipboard = { "unnamed", "unnamedplus" }

vim.diagnostic.config({
  severity_sort = true,
  virtual_lines = false,
  virtual_text = true,
})

local osc52 = require("vim.ui.clipboard.osc52")
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = osc52.copy("+"),
    ["*"] = osc52.copy("*"),
  },
  paste = {
    ["+"] = osc52.paste("+"),
    ["*"] = osc52.paste("*"),
  },
}

-- misc
vim.opt.nrformats:append("alpha")
vim.o.formatoptions = "cr/qn1jp"

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

require("utils").setup()
require("binds")
require("lsp")

require("server").start()
