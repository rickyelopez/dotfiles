local api = vim.api
local M = {}

M.map = function(lhs, rhs, modes, opts)
  modes = modes or { "n" }
  opts = opts or { noremap = true, silent = true }
  vim.keymap.set(modes, lhs, rhs, opts)
end

M.listValidBuffers = function()
  local bufs = vim.api.nvim_list_bufs()
  local validBufs = {}

  for _, buf in ipairs(bufs) do
    if vim.fn.buflisted(buf) == 1 then
      table.insert(validBufs, buf)
    end
  end

  return validBufs
end

-- should probably port these to pure lua at some point
api.nvim_exec(
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

api.nvim_exec(
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

api.nvim_exec(
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
