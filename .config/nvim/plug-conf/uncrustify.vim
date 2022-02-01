
let g:uncrustify_config_file = $HOME . "/.config/uncrustify2.cfg"
let g:uncrustify_debug = 0

autocmd FileType \(cpp\|c\) noremap <buffer> <leader>f :call Uncrustify()<CR>
" autocmd FileType \(cpp\|c\) vnoremap <buffer> <leader>f :call RangeUncrustify('c')<CR>
