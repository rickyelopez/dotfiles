nnoremap <leader>cr :LspRestart<CR>

" clangd
nnoremap <leader>o :ClangdSwitchSourceHeader<CR>

" Unmap meta
silent! unmap <M-p>
silent! unmap <M-n>
silent! unmap <M-o>
silent! unmap Q

command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis
