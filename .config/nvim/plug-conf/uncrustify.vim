
" let g:uncrustify_cfg_file_path = "$HOME/.config/uncrustify.cfg"
let g:uncrustify_cfg_file_path = "$HOME/.config/uncrustify2.cfg"
" let g:uncrustify_cfg_file_path = "$HOME/repos/uncrustify/etc/msvc.cfg"

autocmd FileType c noremap <buffer> <leader>f :call Uncrustify('c')<CR>
autocmd FileType c vnoremap <buffer> <leader>f :call RangeUncrustify('c')<CR>
autocmd FileType cpp noremap <buffer> <leader>f :call Uncrustify('cpp')<CR>
autocmd FileType cpp vnoremap <buffer> <leader>f :call RangeUncrustify('cpp')<CR>
