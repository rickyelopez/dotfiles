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
set inccommand="split"
set showmatch
set clipboard=unnamedplus
set scrolloff=10

" set leader
let mapleader = " "

" coc defs
set hidden
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

set colorcolumn=72
highlight ColorColumn ctermbg=0 guibg=lightgrey

autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
let g:plug_window = 'noautocmd vertical topleft new'


" if executable('rg')
" 	let g:rg_derive_root='true'
" endif

" remap window navigation functions
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>

"nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
map <leader>pv :NERDTreeToggle<CR>
nnoremap <leader>ps :Rg<SPACE>

" make functionality
" nnoremap <leader>b :exe 'Make'<bar>Copen<CR>
nnoremap <leader>p :Copen<CR>
let g:neomake_open_list = 2


if has("patch-8.1.1564")
	" Recently vim can merge signcolumn and number column into one
	set signcolumn=number
else
	set signcolumn=yes
endif


" Markdown Preview Bind
nmap <C-m> <Plug>MarkdownPreviewToggle

source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/plug-conf/fzf.vim
source $HOME/.config/nvim/plug-conf/coc.vim
source $HOME/.config/nvim/plug-conf/airline.vim
source $HOME/.config/nvim/plug-conf/theme.vim

