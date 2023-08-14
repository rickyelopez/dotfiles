local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup({
    function(use)
        use("wbthomason/packer.nvim")
        use("lewis6991/impatient.nvim")

        use('ojroques/nvim-osc52')

        use("williamboman/mason.nvim")
        use("williamboman/mason-lspconfig.nvim")
        use("neovim/nvim-lspconfig")

        use("p00f/clangd_extensions.nvim")

        use("jose-elias-alvarez/null-ls.nvim")

        -- completion
        use("hrsh7th/cmp-nvim-lsp")
        use("hrsh7th/cmp-buffer")
        use("hrsh7th/cmp-path")
        use("hrsh7th/cmp-cmdline")
        use("hrsh7th/cmp-vsnip")
        use("hrsh7th/nvim-cmp")

        -- snippets
        use("hrsh7th/vim-vsnip")
        use("hrsh7th/vim-vsnip-integ")

        -- treesitter
        use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
        use("nvim-treesitter/playground")
        use("nvim-treesitter/nvim-treesitter-context")

        -- tpope plugins
        use("tpope/vim-commentary")
        use("tpope/vim-fugitive")
        use("tpope/vim-surround")
        use("tpope/vim-dispatch")

        -- git plugins
        use("sindrets/diffview.nvim")
        use("APZelos/blamer.nvim")
        use("lewis6991/gitsigns.nvim")

        -- Merge conflicts
        use("rhysd/conflict-marker.vim")

        use({
            "junegunn/fzf.vim",
            requires = { "junegunn/fzf", run = ":call fzf#install()" },
        })

        use("airblade/vim-rooter")

        use("vim-utils/vim-man")
        use("mbbill/undotree")

        use("jiangmiao/auto-pairs")

        -- python
        use({ "numirias/semshi", run = ":UpdateRemotePlugins" })

        -- lualine
        use("RRethy/nvim-base16")
        use("nvim-lualine/lualine.nvim")

        -- formatting
        -- use("rickyelopez/vim-uncrustify")
        use("rickyelopez/uncrustify.nvim")

        -- color schemes
        use("chriskempson/base16-vim")
        use("norcalli/nvim-colorizer.lua")
        use("folke/tokyonight.nvim")
        use("rebelot/kanagawa.nvim")


        -- indent guides
        use("lukas-reineke/indent-blankline.nvim")

        -- Buffer line
        use("kyazdani42/nvim-web-devicons")
        use("akinsho/nvim-bufferline.lua")

        -- toggleterm
        use({ "akinsho/toggleterm.nvim", tag = "*" })
        use("da-moon/telescope-toggleterm.nvim")

        -- LSP Trouble
        -- use 'folke/lsp-trouble.nvim'

        -- this needs to be fixed if I want it
        -- use 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

        -- telescope
        use("nvim-lua/popup.nvim")
        use("nvim-lua/plenary.nvim")
        use("nvim-telescope/telescope.nvim")
        use("nvim-telescope/telescope-fzy-native.nvim")
        use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

        -- file browser
        use("MunifTanjim/nui.nvim")
        use("nvim-neo-tree/neo-tree.nvim")

        -- CSV handling
        use("chrisbra/csv.vim")

        -- mako handling
        use("sophacles/vim-bundle-mako")

        -- Rust
        use("rust-lang/rust.vim")

        -- plugins from dotfiles_priv
        local ok, privPlugins = pcall(require, "lua-priv.plugins")
        if ok and privPlugins then
            use(privPlugins)
        end

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if packer_bootstrap then
            require("packer").sync()
        end
    end,
    config = {
        profile = {
            enable = true,
            threshold = 0.2,
        },
    },
})
