if has('nvim')
	" Neovim specific commands
	call plug#begin(stdpath('data') . '/plugged')
else
	" Standard vim specific commands
	call plug#begin('~/vimfiles/plugged')
endif

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'

Plug 'jremmen/vim-ripgrep'
Plug 'lyuts/vim-rtags'

Plug 'vim-utils/vim-man'
Plug 'neoclide/coc.nvim', {'branch':'release'}
Plug 'mbbill/undotree'
Plug 'preservim/nerdtree'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-scripts/Arduino-syntax-file'
Plug 'neomake/neomake'
Plug 'jiangmiao/auto-pairs'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" color schemes
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'

call plug#end()
