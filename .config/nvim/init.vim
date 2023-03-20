" init.vim
" Set VIM preferences

syntax on

" map leader key to space
let mapleader = " "

" add mouse support
set mouse=a

" allow buffer switching
set hidden
" remove bell
set noerrorbells visualbell t_vb=
" setup tabbing
set tabstop=4 softtabstop=0 shiftwidth=0 expandtab smarttab
set autoindent smartindent

set cursorline
set nowrap
set noswapfile
set nobackup
set nowritebackup
set undodir=~/.vimfiles/undodir
set undofile
set showmatch
set scrolloff=5
set termguicolors

" make things more responsive
set updatetime=300
set ttimeoutlen=10

" command bar
set cmdheight=2
set shortmess+=c

set nrformats+=alpha
set formatoptions+=j

" show whitespace and line break
set list
set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮,tab:▷▷⋮
set shiftround
" set linebreak
" let &showbreak='↪ '

" searching
set incsearch
set ignorecase
set smartcase
set inccommand=nosplit

" setup number column
set number relativenumber
" set signcolumn=number
" set signcolumn=auto:3
set signcolumn=yes

" set column at line length limit
set colorcolumn=120

" don't fold anything when opening files
set foldlevel=99

" session specific configs
if filereadable($HOME . "/copypaste/pbcopy-remote")
    let g:clipboard = {
        \   'name': 'tmux_clipboard',
        \   'copy': {
        \      '+': $HOME . '/copypaste/pbcopy-remote',
        \      '*': $HOME . '/copypaste/pbcopy-remote',
        \    },
        \   'paste': {
        \      '+': $HOME . '/copypaste/pbpaste-remote',
        \      '*': $HOME . '/copypaste/pbpaste-remote',
        \   },
        \   'cache_enabled': 1,
        \ }
endif
set clipboard+=unnamedplus

" set python3 path
let g:python3_host_prog='/usr/bin/python3'

" nerd tree config
" autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
let g:plug_window = 'noautocmd vertical topleft new'

" python config
" au BufNewFile,BufRead *.py \
"   set foldmethod=indent
let g:python_highlight_all = 1

" DBC syntax
au BufRead,BufNewFile *.dbc set filetype=dbc

" disable rooter
let g:rooter_manual_only = 1

let g:vsnip_snippet_dir = $HOME . '/.config/nvim/vsnip'

" Load supplemental configs
" source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/utils.vim
" source $HOME/.config/nvim/plug-conf/uncrustify.vim
source $HOME/.config/nvim/plug-conf/fzf.vim
" source $HOME/.config/nvim/plug-conf/blamer.vim
" source $HOME/.config/nvim/plug-conf/autopairs.vim


function! Update_compiledb(path)
    let s:full_path = getcwd() . "/" . a:path
    :silent exec "!ln -sf " .. s:full_path
    " :silent exec "LspRestart clangd"
endfunction

lua << EOF
  require("init")
EOF

" use cpp comments in c files by default
autocmd FileType \(cpp\|c\) set commentstring=//\ %s
