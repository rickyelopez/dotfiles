" python root dir discovery
autocmd FileType python let b:coc_root_patterns = ['pyproject.toml', 'pyrightconfig.json', '.git', 'env', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py']

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

" Autofix problem on current line
nmap <leader>cf  <Plug>(coc-fix-current)

nmap <C-b> :CocCommand python.execInTerminal<CR>

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" ctrl-space to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" " COC autocomplete menu settings
" " Use CR for completion
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" " navigate with tab and shift+tab
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" " Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()

" " coc-snippets
" let g:coc_snippet_next = '<tab>'
" " Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)
" " Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)


if !empty($BLACKCFG)
    call coc#config("python.formatting.blackArgs", ["--config", $BLACKCFG])
endif
call coc#config("python.linting.pylintArgs", ["--rcfile", $RCFILE])
call coc#config("clangd.path", $CLANGD_PATH)

" highlight disabled codepaths in grey
" hi! link CocSem_comment TSComment
