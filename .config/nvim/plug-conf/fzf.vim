" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_buffers_jump = 1

map <C-p> :Files<CR>
map <leader>b :Buffers<CR>
nnoremap <leader>gg :RG<CR>
" nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :Marks<CR>

let g:fzf_tags_command = 'ctags -R --options=./.ctags'

" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.9, 'height': 0.9,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

" Ignored files
let g:ignored_files = "-g '!.git/**' -g '!*.msr' -g '!*.gvl' -g '!*.map' -g '!*.asm' -g '!*.pyc' -g '!*.png' -g '!*.o' -g '!*.asms' -g '!*.asmss' -g '!*.c.html'"

let g:fzf_cmd = "rg --files --hidden " . g:ignored_files
let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
let $FZF_DEFAULT_COMMAND = g:fzf_cmd . " --no-ignore"

let g:grep_base_cmd = "rg --column --line-number --no-heading --color=always --smart-case " . g:ignored_files
let g:grep_with_vcs = g:grep_base_cmd . " --no-ignore-vcs %s || true"
let g:grep_no_vcs = g:grep_base_cmd . " %s || true"

" include vcs by default
let g:grep_cmd = g:grep_with_vcs

let g:fzf_git_ignore = 0

function! ToggleGitIgnore()
	if g:fzf_git_ignore
		let g:fzf_git_ignore = 0
		let $FZF_DEFAULT_COMMAND = g:fzf_cmd . " --no-ignore"
        let g:grep_cmd = g:grep_with_vcs
		echo "now ignoring .gitignore"
	else
		let g:fzf_git_ignore = 1
		let $FZF_DEFAULT_COMMAND = g:fzf_cmd
        let g:grep_cmd = g:grep_no_vcs
		echo "now respecting .gitignore"
	endif
endfunction

nmap <leader>fg :call ToggleGitIgnore()<CR>

" Customize fzf colors to match your color scheme
" let g:fzf_colors = {
"   \ 'fg':      ['fg', 'Normal'],
"   \ 'bg':      ['bg', 'Normal'],
"   \ 'hl':      ['fg', 'Comment'],
"   \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"   \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"   \ 'hl+':     ['fg', 'Statement'],
"   \ 'info':    ['fg', 'PreProc'],
"   \ 'border':  ['fg', 'Ignore'],
"   \ 'prompt':  ['fg', 'Conditional'],
"   \ 'pointer': ['fg', 'Exception'],
"   \ 'marker':  ['fg', 'Keyword'],
"   \ 'spinner': ['fg', 'Label'],
"   \ 'header':  ['fg', 'Comment'] }

"Get Files
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let initial_command = printf(g:grep_cmd, shellescape(a:query))
  let reload_command = printf(g:grep_cmd, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)


" " Get text in files with Rg
" command! -bang -nargs=* Rg
"   \ call fzf#vim#grep(
"   \   "rg --column --line-number --no-heading --color=always --smart-case --glob '!.git/**' ".shellescape(<q-args>), 1,
"   \   fzf#vim#with_preview(), <bang>0)

"  " Make Ripgrep ONLY search file contents and not filenames
" command! -bang -nargs=* Rg
"   \ call fzf#vim#grep(
"   \   'rg --column --line-number --hidden --smart-case --no-heading --color=always '.shellescape(<q-args>), 1,
"   \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
"   \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4.. -e'}, 'right:50%', '?'),
"   \   <bang>0)
