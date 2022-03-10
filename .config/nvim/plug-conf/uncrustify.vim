
let g:uncrustify_config_file = $HOME . "/.config/uncrustify2.cfg"
" let g:uncrustify_debug = 1

autocmd FileType \(cpp\|c\) noremap <buffer> <leader>f :Uncrustify<CR>
autocmd FileType \(cpp\|c\) vnoremap <buffer> <leader>f :UncrustifyRange<CR>

" autocmd FileType c noremap <buffer> <leader>f :call Uncrustify('c')<CR>
" autocmd FileType c vnoremap <buffer> <leader>f :call RangeUncrustify('c')<CR>

" autocmd FileType cpp noremap <buffer> <leader>f :call Uncrustify('cpp')<CR>
" autocmd FileType cpp vnoremap <buffer> <leader>f :call RangeUncrustify('cpp')<CR>
