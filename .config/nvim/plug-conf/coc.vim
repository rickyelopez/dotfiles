" coc maps
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f <Plug>(coc-format)
nmap <leader>f <Plug>(coc-format)

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nmap <A-o> :CocCommand clangd.switchSourceHeader<CR>

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Fix autofix problem of current line
nmap <leader>cf  <Plug>(coc-fix-current)


" COC autocomplete menu settings
" Use CR for completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" navigate with tab and shift+tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" inoremap <silent><expr> <TAB>
" 	\ pumvisible() ? "\<C-n>" :
"     " \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
" 	\ <SID>check_back_space() ? "\<TAB>" :
" 	\ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" coc-snippets
let g:coc_snippet_next = '<tab>'
" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)
" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)


function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

call coc#config("python.formatting.blackArgs", ["--config", $REPO_PATH . "/libs/python/blackcfg.toml"])
call coc#config("python.linting.pylintArgs", ["--rcfile", $RCFILE])
call coc#config("python.autoComplete.extraPaths", [$EXTRA_PATHS_1, $EXTRA_PATHS_2])
call coc#config("clangd.path", $CLANGD_PATH)

" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
