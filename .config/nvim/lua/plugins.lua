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

require("lazy").setup({
  { import = "plug-conf" },

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

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" }, { RRGGBBAA = true })
    end,
    priority = 1,
  },
  "tpope/vim-commentary",
  "tpope/vim-surround",
  "mbbill/undotree",
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  { "sophacles/vim-bundle-mako", ft = "mako" },
  { "rust-lang/rust.vim", ft = "rust" },
  { "rickyelopez/uncrustify.nvim", lazy = true },
})
