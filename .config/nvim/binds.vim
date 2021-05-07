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

" clear highligted search
nnoremap <leader><space> :noh<CR>

" nerdtree config
nnoremap <leader>pv :NERDTreeToggle<CR>
nnoremap \ :NERDTreeFind<CR>

" Remove all trailing wHitespace by pressing hotkey
nnoremap <leader>ws :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" scratchpad
nnoremap <leader>sc :e ~/scratchpad.c<CR>
nnoremap <leader>sp :e ~/scratchpad.py<CR>
