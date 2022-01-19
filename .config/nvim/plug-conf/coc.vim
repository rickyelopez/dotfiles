" coc maps
nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>cr :CocRestart<CR>

" autocmd FileType *\(cpp\|c\)\@<! xmap <leader>f <Plug>(coc-format-selected)
" autocmd FileType *\(cpp\|c\)\@<! nmap <leader>f <Plug>(coc-format)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format)

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nmap <leader>o :CocCommand<Space>clangd.switchSourceHeader<CR>

" show documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Fix autofix problem of current line
nmap <leader>cf  <Plug>(coc-fix-current)

nmap <C-b> :CocCommand python.execInTerminal<CR>
nmap <A-o> :CocCommand clangd.switchSourceHeader<CR>

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" nnoremap <Leader>f :<C-u>ClangFormat<CR>

" ctrl-space to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

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
" vmap <C-j> <Plug>(coc-snippets-select)
vmap <C-j> <Plug>(coc-snippets-select)


function! s:check_back_space() abort
	let col = col('.') - 1
endfunction

if !empty($BLACK_ARGS)
    call coc#config("python.formatting.blackArgs", ["--config", $REPO_PATH . "/libs/python/blackcfg.toml"])
endif
call coc#config("python.linting.pylintArgs", ["--rcfile", $RCFILE])
call coc#config("python.autoComplete.extraPaths", [$EXTRA_PATHS])
call coc#config("clangd.path", $CLANGD_PATH)

function! Update_compiledb(path)
    let s:full_path = getcwd() . "/" . a:path
    let g:tmp = s:full_path
    call coc#config("clangd.compilationDatabasePath", s:full_path)
endfunction

" call coc#config("clangd.arguments", ["-style=\"{`sed -e '/^\s*#.*$/d;/^\s*$/d' ~/.config/clangd/.clang-format | sed -z 's/\([^{:]\)\n/\1, /g; s/\([{:]\)\n/\1 /g; s/, }/}/g; s/, $/\n/'`}\""])

" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"
"
hi! link CocSem_comment TSComment
