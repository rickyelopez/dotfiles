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
" map <leader>b :Buffers<CR>
nnoremap <leader>gg :RG<CR>
nnoremap <leader>gw :RGw<CR>
" nnoremap <leader>t :Tags<CR>
" nnoremap <leader>m :Marks<CR>

" let g:fzf_tags_command = 'ctags -R --options=./.ctags'

" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.9, 'height': 0.9,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

" Ignored files
let g:ignored_files    = "-g '!.git/**' -g '!**/.cache/**' -g '!*.msr' -g '!*.gvl' -g '!*.map' -g '!*.asm' -g '!*.pyc' -g '!*.png' -g '!*.o' -g '!*.asms' -g '!*.asmss' -g '!*.c.html' -g '!*.compact.json' -g '!*.json.raw' -g '!*.html'"
let g:fd_ignored_files = "-E .git -E .cache -E .msr -E .gvl -E .map -E .asm -E .pyc -E .png -E .o -E .asms -E .asmss -E .c.html -E .compact.json -E .json.raw -E .html"

let s:fzf_base_cmd = "fd --hidden --type file " . g:fd_ignored_files
" let s:fzf_base_cmd = "rg --files --hidden " . g:ignored_files
let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
let $FZF_DEFAULT_COMMAND = s:fzf_base_cmd . " --no-ignore-vcs"

let s:grep_base_cmd = "rg --hidden --column --line-number --no-heading --color=always --smart-case " . g:ignored_files
let s:grep_suffix = " %s"

" include vcs by default
let g:fzf_git_ignore = 0

function! ToggleGitIgnore()
    if g:fzf_git_ignore
        let g:fzf_git_ignore = 0
        let $FZF_DEFAULT_COMMAND = s:fzf_base_cmd . " --no-ignore-vcs"
        let g:grep_ignore = " --no-ignore-vcs"
        echo "now ignoring .gitignore"
    else
        let g:fzf_git_ignore = 1
        let $FZF_DEFAULT_COMMAND = s:fzf_base_cmd
        let g:grep_ignore = ""
        echo "now respecting .gitignore"
    endif

    let s:grep_cmd = s:grep_base_cmd . g:grep_ignore . s:grep_suffix
endfunction

silent call ToggleGitIgnore()

nmap <leader>fg :call ToggleGitIgnore()<CR>

"Get Files
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let initial_command = printf(s:grep_cmd, shellescape(a:query))
  let reload_command = printf(s:grep_cmd, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
command! RGw call RipgrepFzf(expand('<cword>'), 0)

" Git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
