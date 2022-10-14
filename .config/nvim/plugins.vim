if has('nvim')
	" Neovim specific commands
	call plug#begin(stdpath('data') . '/plugged')

" LSP
Plug 'neoclide/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile' }

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'

" tmux clipboard
Plug 'roxma/vim-tmux-clipboard'

" git stuff
Plug 'sindrets/diffview.nvim'
Plug 'APZelos/blamer.nvim'
" Merge conflicts
Plug 'rhysd/conflict-marker.vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'

Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'

Plug 'jiangmiao/auto-pairs'

" python
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" formatting
" Plug 'cofyc/vim-uncrustify'
" Plug 'embear/vim-uncrustify'
Plug 'rickyelopez/vim-uncrustify'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" color schemes
Plug 'chriskempson/base16-vim'
Plug 'folke/tokyonight.nvim' 
" Plug 'drewtempelmeyer/palenight.vim'

" indent guides
Plug 'lukas-reineke/indent-blankline.nvim'
" Plug 'Yggdroot/indentLine'

" Buffer line
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/nvim-bufferline.lua'

" LSP Trouble
" Plug 'folke/lsp-trouble.nvim'

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" file browser
" Plug 'preservim/nerdtree'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'

" mako
Plug 'sophacles/vim-bundle-mako'

" todo
Plug 'aserebryakov/vim-todo-lists'

" CSV handling
Plug 'chrisbra/csv.vim'

" Rust
Plug 'rust-lang/rust.vim'

call plug#end()

endif
