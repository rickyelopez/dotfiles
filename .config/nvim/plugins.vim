if has('nvim')
	" Neovim specific commands
	call plug#begin(stdpath('data') . '/plugged')
else
	" Standard vim specific commands
	call plug#begin('~/vimfiles/plugged')
endif


" LSP
Plug 'neoclide/coc.nvim', {'branch':'release'}
Plug 'rhysd/vim-clang-format'
Plug 'jackguo380/vim-lsp-cxx-highlight'
" Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'

" git diff
Plug 'sindrets/diffview.nvim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'

Plug 'lyuts/vim-rtags'

Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'preservim/nerdtree'

Plug 'neomake/neomake'
Plug 'jiangmiao/auto-pairs'

" python
Plug 'Vimjas/vim-python-pep8-indent'

" syntax
Plug 'vim-python/python-syntax'
Plug 'jackguo380/vim-lsp-cxx-highlight'

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" linting
Plug 'vim-syntastic/syntastic'

" formatting
Plug 'rhysd/vim-clang-format'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" color schemes
Plug 'chriskempson/base16-vim'
Plug 'folke/tokyonight.nvim' 
Plug 'drewtempelmeyer/palenight.vim'

" indent guides
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'Yggdroot/indentLine'

" Buffer line
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/nvim-bufferline.lua'

" LSP Trouble
Plug 'folke/lsp-trouble.nvim'

" snippets
" Plug 'SirVer/ultisnips'

" todo
Plug 'aserebryakov/vim-todo-lists'

call plug#end()
