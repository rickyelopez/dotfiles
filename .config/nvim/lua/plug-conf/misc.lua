-- config snippets that don't merit a whole file


-- set python3 path
vim.g.python3_host_prog='/usr/bin/python3'

-- nerd tree config
-- autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif

-- vim plugged config
-- vim.g.plug_window = 'noautocmd vertical topleft new'

-- python config
-- vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
--     pattern = {"*.py"},
--     command = "set foldmethod=indent",
-- })
vim.g.python_highlight_all = 1

-- disable rooter
vim.g.rooter_manual_only = 1

-- set snippet dir
vim.g.vsnip_snippet_dir = vim.fn.expand("$HOME")..'/.config/nvim/vsnip'


-- enable dbc syntax highlighting
vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
    pattern = {"*.dbc"},
    command = "set filetype=dbc",
})

-- use cpp comment style in c files and cpp files
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"cpp", "c"},
    command = [[set commentstring=//\ %s]],
})
