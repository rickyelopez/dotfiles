local M = {}

--- Add a keymap with default mode set to "n"
--- @param lhs string the keymap
--- @param rhs string|function action to perform
--- @param modes string|table? modes for this bind. Defaults to { "n" }
--- @param opts vim.keymap.set.Opts?
function M.map(lhs, rhs, modes, opts)
  modes = modes or { "n" }
  opts = opts or { noremap = true, silent = true }
  vim.keymap.set(modes, lhs, rhs, opts)
end

function M.listValidBuffers()
  local bufs = vim.api.nvim_list_bufs()
  local validBufs = {}

  for _, buf in ipairs(bufs) do
    if vim.fn.buflisted(buf) == 1 then
      table.insert(validBufs, buf)
    end
  end

  return validBufs
end

function M.setup()
  -- enable dbc syntax highlighting
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.dbc" },
    command = "set filetype=dbc",
  })

  -- use cpp comment style in c files and cpp files
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "cpp", "c" },
    command = [[set commentstring=//\ %s]],
  })

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "ZIP_BUILD" },
    command = [[set ft=python]],
  })

  -- should probably port this to pure lua at some point
  vim.api.nvim_exec2(
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
    {}
  )
end

return M
