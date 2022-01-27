if stridx(hostname(), "ci-dev") == -1
    let g:python3_host_prog='/usr/bin/python3'
    " let g:python_host_prog='/usr/bin/python2' 
else

    let g:python3_host_prog = "/usr/bin/python"

    let g:clipboard = {
        \   'name': 'tmux_clipboard',
        \   'copy': {
        \      '+': '/nfs_home/ricclopez/copypaste/pbcopy-remote',
        \      '*': '/nfs_home/ricclopez/copypaste/pbcopy-remote',
        \    },
        \   'paste': {
        \      '+': '/nfs_home/ricclopez/copypaste/pbpaste-remote',
        \      '*': '/nfs_home/ricclopez/copypaste/pbpaste-remote',
        \   },
        \   'cache_enabled': 1,
        \ }

endif

syntax on

" map leader key to space
let mapleader = " "

" add mouse support
set mouse=a

" general config
set hidden
set noerrorbells
set visualbell
set t_vb=
set tabstop=4 softtabstop=0 shiftwidth=0 expandtab smarttab
set smartindent
set number
set relativenumber
set nowrap
set noswapfile
set nobackup
set undodir=~/.vimfiles/undodir
set undofile
set showmatch
set clipboard+=unnamedplus
set scrolloff=10
set termguicolors
set updatetime=300

" show whitespace and line break
set list
set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮
set shiftround
" set linebreak
" let &showbreak='↪ '

" searching
set incsearch
set ignorecase
set smartcase
set inccommand=nosplit

" coc defs
set nowritebackup
set cmdheight=2
set shortmess+=c
set signcolumn=number

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

" don't fold anything when opening files
set foldlevel=99

" nerd tree config
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
let g:plug_window = 'noautocmd vertical topleft new'
map <leader>pv :NERDTreeToggle<CR>

" close buffer without closing window
nnoremap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" python config
" au BufNewFile,BufRead *.py \
"   set foldmethod=indent
let g:python_highlight_all = 1

" DBC syntax
au BufRead,BufNewFile *.dbc set filetype=dbc

" python syntax highlighting
let g:python_highlight_all = 1

" enable italics for palenight
let g:palenight_terminal_italics=1

" Markdown Preview Bind
nmap <C-m> <Plug>MarkdownPreviewToggle

" linting settings
" let g:syntastic_cpp_checkers = ['cpplint']
" let g:syntastic_c_checkers = ['cpplint']
" let g:syntastic_cpp_cpplint_exec = 'cpplint'
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" use cpp comments in c files by default
autocmd FileType c,cpp set commentstring=//\ %s

" python root dir
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyrightconfig.json', 'pyproject.toml']

" disable rooter
let g:rooter_manual_only = 1

" Load supplemental configs
source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/binds.vim
source $HOME/.config/nvim/plug-conf/theme.vim
source $HOME/.config/nvim/plug-conf/ultisnips.vim
source $HOME/.config/nvim/plug-conf/coc.vim
source $HOME/.config/nvim/plug-conf/uncrustify.vim " load after coc so that format keybinds are set correctly
source $HOME/.config/nvim/plug-conf/airline.vim
source $HOME/.config/nvim/plug-conf/fzf.vim
source $HOME/.config/nvim/plug-conf/treesitter.vim
source $HOME/.config/nvim/plug-conf/telescope.vim

lua << EOF
  require("init")
EOF

