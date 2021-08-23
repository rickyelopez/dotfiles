if stridx(hostname(), "ci-dev") == -1

    " if has("macunix")
    "   " fix python 2
    "   let g:python_host_prog = "/usr/bin/python"
    " else
      let g:python3_host_prog='/usr/local/bin/python3'
      let g:python_host_prog='/usr/local/bin/python' 
    " endif

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

" fix mouse in tmux
set mouse=a

" general config
set noerrorbells
set visualbell
set t_vb=
set tabstop=4 softtabstop=0 shiftwidth=4 expandtab smarttab
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

" searching
set incsearch
set ignorecase
set smartcase
set inccommand=nosplit

" map leader key to space
let mapleader = " "

" coc defs
set hidden
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey


" Load supplemental configs
source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/binds.vim
source $HOME/.config/nvim/plug-conf/theme.vim
source $HOME/.config/nvim/plug-conf/ultisnips.vim
source $HOME/.config/nvim/plug-conf/coc.vim
source $HOME/.config/nvim/plug-conf/airline.vim
source $HOME/.config/nvim/plug-conf/fzf.vim
source $HOME/.config/nvim/plug-conf/lsptrouble.vim
source $HOME/.config/nvim/plug-conf/treesitter.vim

" bufferline setup
lua << EOF
  require("bufferline").setup{}
EOF

" nerd tree config
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
let g:plug_window = 'noautocmd vertical topleft new'

" c++ syntax highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

" make functionality
" nnoremap <leader>b :exe 'Make'<bar>Copen<CR>
" nnoremap <leader>p :Copen<CR>
let g:neomake_open_list = 2

" python config
" au BufNewFile,BufRead *.py \
"   set foldmethod=indent
let g:python_highlight_all = 1

" DBC syntax
au BufRead,BufNewFile *.dbc set filetype=dbc

" adjust c comments
autocmd FileType c,cpp set commentstring=//\ %s

" clang format
let g:clang_format#command = "~/clang+llvm/bin/clang-format -style=$HOME/.config/clangd/.clang-config"

" python root dir
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyrightconfig.json', 'pyproject.toml']

" disable rooter
let g:rooter_manual_only = 1

