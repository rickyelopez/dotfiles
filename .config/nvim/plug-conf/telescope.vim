let g:rg_files_cmd = split($FZF_DEFAULT_COMMAND)

nnoremap <leader>tg :lua require('telescope.builtin').live_grep({ prompt_prefix = "🔍 ", additional_args = function(opts) return vim.g.ignored_files end})<CR>
" nnoremap <leader>ggd :lua require('telescope.builtin').live_grep({ cwd="$fw/$di" })<CR>
nnoremap <leader>gcr :lua require('telescope.builtin').live_grep({ cwd="$fw/$cr" })<CR>
" nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>tp :lua require('telescope.builtin').find_files({ prompt_prefix = "🔍 ", find_command = vim.g.rg_files_cmd })<CR>
" nnoremap <Leader>tg :lua require('telescope.builtin').git_files()<CR>

vnoremap <leader>tw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>b :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>vh :lua require('telescope.builtin').help_tags()<CR>

nnoremap <leader>m :lua require('telescope.builtin').marks()<CR>

nnoremap <leader>ts :lua require('telescope.builtin').treesitter()<CR>

nnoremap <leader>vrc :lua require('plug-conf.telescope').search_dotfiles()<CR>
nnoremap <leader>tf :lua  require('plug-conf.telescope').select_compiledb()<CR>
