" remap window navigation functions
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>

" Markdown Preview Bind
nmap <leader>md <Plug>MarkdownPreviewToggle

" Markdown Preview Bind
nmap <C-m> <Plug>MarkdownPreviewToggle
" close buffer without closing window
" nnoremap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <leader>q :bp<bar>bd #<CR>

" bind buffer switching
" nnoremap <S-Tab> :bn<CR>
" nnoremap <leader><S-Tab> :bp<CR>
nnoremap <S-Tab> :BufferLineCycleNext<CR>
nnoremap <leader><S-Tab> :BufferLineCyclePrev<CR>
" These commands will move the current buffer backwards or forwards in the bufferline
nnoremap <silent><leader><S-L> :BufferLineMoveNext<CR>
nnoremap <silent><leader><S-H> :BufferLineMovePrev<CR>
" buffer pick
nnoremap <silent> gb :BufferLinePick<CR>
" goto buffer

nnoremap <silent><leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
nnoremap <silent><leader>2 <Cmd>BufferLineGoToBuffer 2<CR>
nnoremap <silent><leader>3 <Cmd>BufferLineGoToBuffer 3<CR>
nnoremap <silent><leader>4 <Cmd>BufferLineGoToBuffer 4<CR>
nnoremap <silent><leader>5 <Cmd>BufferLineGoToBuffer 5<CR>
nnoremap <silent><leader>6 <Cmd>BufferLineGoToBuffer 6<CR>
nnoremap <silent><leader>7 <Cmd>BufferLineGoToBuffer 7<CR>
nnoremap <silent><leader>8 <Cmd>BufferLineGoToBuffer 8<CR>
nnoremap <silent><leader>9 <Cmd>BufferLineGoToBuffer 9<CR>

" clear highligted search
nnoremap <leader><space> :noh<CR>

" nerdtree config
nnoremap <leader>pv :NERDTreeToggle<CR>
nnoremap \ :NERDTreeFind<CR>

" Remove all trailing whitespace by pressing hotkey
nnoremap <leader>ws :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" scratchpad
nnoremap <leader>sc :e ~/scratchpad.c<CR>
nnoremap <leader>sp :e ~/scratchpad.py<CR>

nnoremap <S-q> <silent>

" reselect block after indenting
vnoremap < <gv
vnoremap > >gv

" make Y consistent with C and D
nnoremap Y y$

" autocenter
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz
nnoremap <silent> <C-o> <C-o>zz
nnoremap <silent> <C-i> <C-i>zz

" regex when searching or replacing
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
