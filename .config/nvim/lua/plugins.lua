--- Plugin manager configuration

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins from dotfiles_priv
local ok, privPlugins = pcall(require, "lua-priv.plugins")
if not ok or not privPlugins then
  privPlugins = {}
end

require("lazy").setup({
  { import = "plug-conf" },

  { "folke/neodev.nvim", opts = {} },

  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf", build = ":call fzf#install()" },
  },

  { "numirias/semshi", build = ":UpdateRemotePlugins" },

  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    config = function()
      local map = require("utils").map
      -- start markdown preview
      map("<leader>md", "<Plug>MarkdownPreviewToggle")
    end,
  },

  { "tpope/vim-fugitive", enabled = false },
  { "tpope/vim-dispatch", enabled = false },
  { "norcalli/nvim-colorizer.lua", config = true, priority = 1 },
  { "chrisbra/csv.vim", enabled = false },
  { "airblade/vim-rooter", enabled = false },
  "tpope/vim-commentary",
  "tpope/vim-surround",
  "ojroques/nvim-osc52",
  "mbbill/undotree",
  "lukas-reineke/indent-blankline.nvim",
  "sophacles/vim-bundle-mako",
  "rust-lang/rust.vim",
  "p00f/clangd_extensions.nvim",
  "rickyelopez/uncrustify.nvim",
  -- "rickyelopez/vim-uncrustify",

  privPlugins,
})
