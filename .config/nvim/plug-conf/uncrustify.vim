
" let g:uncrustify_cfg_file_path = "$HOME/.config/uncrustify.cfg"
let g:uncrustify_cfg_file_path = "$HOME/.config/uncrustify2.cfg"

autocmd FileType \(cpp\|c\) noremap <buffer> <leader>f :call Uncrustify('c')<CR>
autocmd FileType \(cpp\|c\) vnoremap <buffer> <leader>f :call RangeUncrustify('c')<CR>
