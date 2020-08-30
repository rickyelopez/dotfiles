syntax on

set noerrorbells
set visualbell
set t_vb=
set tabstop=4 softtabstop=4 shiftwidth=4
set smartindent
set number
set relativenumber
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vimfiles/undodir
set undofile
set incsearch
set showmatch
set clipboard=unnamedplus

" coc defs
set hidden
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

set colorcolumn=72
highlight ColorColumn ctermbg=0 guibg=lightgrey

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
Plug 'morhetz/gruvbox'
Plug 'jremmen/vim-ripgrep'
Plug 'leafgarland/typescript-vim'
Plug 'vim-utils/vim-man'
Plug 'lyuts/vim-rtags'
Plug 'https://github.com/kien/ctrlp.vim.git'
Plug 'neoclide/coc.nvim', {'branch':'release'}
Plug 'mbbill/undotree'
Plug 'preservim/nerdtree'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'https://www.github.com/w0rp/ale'
Plug 'vim-scripts/Arduino-syntax-file'
Plug 'neomake/neomake'
Plug 'coddingtonbear/neomake-platformio'
Plug 'tpope/vim-dispatch'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

call plug#end()


autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
let g:plug_window = 'noautocmd vertical topleft new'

colorscheme gruvbox
set background=dark

if executable('rg')
	let g:rg_derive_root='true'
endif

let mapleader = " "
let g:netrw_browse_split=2
let g:netrw_winsize = 25

let g:ctrlp_use_caching = 0

let g:neomake_open_list = 2

" remap window navigation functions
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>

"nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
map <leader>pv :NERDTreeToggle<CR>
nnoremap <leader>ps :Rg<SPACE>

" make functionality
nnoremap <leader>b :exe 'Make'<bar>Copen<CR>
nnoremap <leader>p :Copen<CR>


" coc maps
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" COC autocomplete menu settings
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
 
" Markdown Preview Bind
nmap <C-m> <Plug>MarkdownPreviewToggle
