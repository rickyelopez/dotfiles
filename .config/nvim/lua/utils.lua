local M = {}

M.map = function(lhs, rhs, modes, opts)
    modes = modes or {"n"}
    opts = opts or { noremap = true, silent = true }
    vim.keymap.set(modes, lhs, rhs, opts)
end

M.addToRTP = function(opts)
    if type(opts) == 'table' then
        for path in opts do
            vim.opt.runtimepath:append("," .. path)
        end
    end
end


-- should probably port these to pure lua at some point
vim.api.nvim_exec(
[[
function! HighlightRepeats() range
  let lineCounts = {}
  let lineNum = a:firstline
  while lineNum <= a:lastline
    let lineText = getline(lineNum)
    if lineText != ""
      let lineCounts[lineText] = (has_key(lineCounts, lineText) ? lineCounts[lineText] : 0) + 1
    endif
    let lineNum = lineNum + 1
  endwhile
  exe 'syn clear Repeat'
  for lineText in keys(lineCounts)
    if lineCounts[lineText] >= 2
      exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
    endif
  endfor
endfunction

command! -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()
command! ClearRepeats :syn<space>clear<space>Repeat
]],
false
)

vim.api.nvim_exec(
[[
function! SynStack ()
    for i1 in synstack(line("."), col("."))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echo n1 "->" n2
    endfor
endfunction
map gm :call SynStack()<CR>
]],
false
)


vim.api.nvim_exec(
[[
function! Update_compiledb(path)
    let s:full_path = getcwd() . "/" . a:path
    :silent exec "!ln -sf " .. s:full_path
    :silent exec "LspStop clangd"
    :silent exec "LspStart clangd"
endfunction
]],
false
)

return M
