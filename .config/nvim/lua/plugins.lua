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
    -- "wbthomason/packer.nvim",
    -- "lewis6991/impatient.nvim",

    -- color schemes
    {
        "folke/tokyonight.nvim",
        priority = 1000 ,
        dependencies = {
            "chriskempson/base16-vim",
            "norcalli/nvim-colorizer.lua",
        }
    },
    -- "rebelot/kanagawa.nvim",

    {
        "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" }
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- snippets
            "hrsh7th/vim-vsnip",
            "hrsh7th/vim-vsnip-integ",
            -- completion
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        }
    },

    -- treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/playground", dependencies = "nvim-treesitter/nvim-treesitter" },
    { "nvim-treesitter/nvim-treesitter-context", dependencies = "nvim-treesitter/nvim-treesitter" },

    -- git plugins
    { "sindrets/diffview.nvim", dependencies = {"kyazdani42/nvim-web-devicons"} },
    "APZelos/blamer.nvim",
    "lewis6991/gitsigns.nvim",
    "rhysd/conflict-marker.vim",

    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf", build = ":call fzf#install()" },
    },

    -- python
    { "numirias/semshi", build = ":UpdateRemotePlugins" },


    -- toggleterm
    { "akinsho/toggleterm.nvim", version = "*" },
    { "da-moon/telescope-toggleterm.nvim", dependencies = "akinsho/toggleterm.nvim" },

    {
        "iamcco/markdown-preview.nvim",
        enabled = false,
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    -- "nvim-lua/popup.nvim",
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzy-native.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        }
    },

    -- misc
    { "akinsho/nvim-bufferline.lua", dependencies = { "kyazdani42/nvim-web-devicons" } },
    { "nvim-lualine/lualine.nvim", dependencies = { "RRethy/nvim-base16" } },
    { "nvim-neo-tree/neo-tree.nvim", dependencies = { "MunifTanjim/nui.nvim" } },
    { "jiangmiao/auto-pairs", enabled = false },
    { "tpope/vim-fugitive", enabled = false },
    { "tpope/vim-dispatch", enabled = false },
    "tpope/vim-commentary",
    "tpope/vim-surround",
    "ojroques/nvim-osc52",
    "airblade/vim-rooter",
    "mbbill/undotree",
    "lukas-reineke/indent-blankline.nvim",
    "chrisbra/csv.vim",
    "sophacles/vim-bundle-mako",
    "rust-lang/rust.vim",
    "p00f/clangd_extensions.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    -- "rickyelopez/vim-uncrustify",
    "rickyelopez/uncrustify.nvim",

    -- -- plugins from dotfiles_priv
    -- local ok, privPlugins = pcall(require, "lua-priv.plugins")
    -- if ok and privPlugins then
    --     use(privPlugins)
    -- end
})
