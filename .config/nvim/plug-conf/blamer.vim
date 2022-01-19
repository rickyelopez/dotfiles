let g:blamer_enabled = 0
let g:blamer_delay = 1000
let g:blamer_show_in_visual_modes = 1
let g:blamer_show_in_insert_modes = 0
let g:blamer_prefix = ' > '
let g:blamer_template = '<committer>, <committer-time> • <summary>'
let g:blamer_date_format = '%y/%m/%d'
let g:blamer_relative_time = 0
highlight Blamer guifg=lightgrey

nnoremap <leader>gb :BlamerToggle<CR>
