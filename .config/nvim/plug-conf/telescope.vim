let g:rg_files_cmd = split($FZF_DEFAULT_COMMAND)

nnoremap <silent><leader>tg :lua require('telescope.builtin').live_grep({ additional_args = function(opts) if vim.g.fzf_git_ignore == 0 then return "--no-ignore-vcs" end end })<CR>
nnoremap <silent><leader>tp :lua require('telescope.builtin').find_files({ find_command = vim.g.rg_files_cmd })<CR>
nnoremap <silent><leader>gcr :lua require('telescope.builtin').live_grep({ cwd="$fw/$cr" })<CR>
" nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
" nnoremap <Leader>tg :lua require('telescope.builtin').git_files()<CR>

vnoremap <silent><leader>tw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <silent><leader>b :lua require('telescope.builtin').buffers()<CR>
nnoremap <silent><leader>vh :lua require('telescope.builtin').help_tags()<CR>

nnoremap <silent><leader>m :lua require('telescope.builtin').marks()<CR>

nnoremap <silent><leader>ts :lua require('telescope.builtin').treesitter()<CR>

nnoremap <silent><leader>vrc :lua require('plug-conf.telescope').search_dotfiles()<CR>
nnoremap <silent><leader>tf :lua  require('plug-conf.telescope').select_compiledb()<CR>
