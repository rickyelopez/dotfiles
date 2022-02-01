nnoremap <leader>tg :lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>gdi :lua require('telescope.builtin').live_grep({ cwd="$fw/$di" })<CR>
nnoremap <leader>gdi3 :lua require('telescope.builtin').live_grep({ cwd="$fw/$dig3" })<CR>
nnoremap <leader>gcr :lua require('telescope.builtin').live_grep({ cwd="$fw/$cr" })<CR>
" nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>tp :lua require('telescope.builtin').find_files()<CR>
" nnoremap <Leader>tg :lua require('telescope.builtin').git_files()<CR>

nnoremap <leader>tw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>b :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>vh :lua require('telescope.builtin').help_tags()<CR>

nnoremap <leader>ts :lua require('telescope.builtin').treesitter()<CR>

nnoremap <leader>vrc :lua require('plug-conf.telescope').search_dotfiles()<CR>
nnoremap <leader>tf :lua  require('plug-conf.telescope').select_compiledb()<CR>
