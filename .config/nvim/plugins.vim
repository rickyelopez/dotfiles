if has('nvim')
	" Neovim specific commands
	call plug#begin(stdpath('data') . '/plugged')
else
	" Standard vim specific commands
	call plug#begin('~/vimfiles/plugged')
endif

Plug 'vim-python/python-syntax'
Plug 'jackguo380/vim-lsp-cxx-highlight'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'

Plug 'lyuts/vim-rtags'

Plug 'vim-utils/vim-man'
Plug 'neoclide/coc.nvim', {'branch':'release'}
Plug 'mbbill/undotree'
Plug 'preservim/nerdtree'
Plug 'neomake/neomake'
Plug 'jiangmiao/auto-pairs'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" color schemes
Plug 'chriskempson/base16-vim'

" snippets
Plug 'SirVer/ultisnips'

call plug#end()