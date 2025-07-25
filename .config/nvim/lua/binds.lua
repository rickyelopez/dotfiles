local map = require("utils").map

-- make j/k treat wrapped lines as regular
map("j", "gj")
map("k", "gk")

-- add window navigation shortcuts
map("<leader>h", "<CMD>wincmd h<CR>")
map("<leader>j", "<CMD>wincmd j<CR>")
map("<leader>k", "<CMD>wincmd k<CR>")
map("<leader>l", "<CMD>wincmd l<CR>")

-- resize windows
map("<C-Left>", "5<C-w><")
map("<C-Down>", "5<C-w>-")
map("<C-Up>", "5<C-w>+")
map("<C-Right>", "5<C-w>>")

-- move lines and correct indent in visual mode
map("<c-j>", ":m '>+1<CR>gv=gv", { "v" })
map("<c-k>", ":m '<-2<CR>gv=gv", { "v" })

-- autocenter after these operations that move the cursor
map("n", "nzz")
map("N", "Nzz")
map("*", "*zz")
map("#", "#zz")
map("g*", "g*zz")
map("g#", "g#zz")
-- map("<C-o>", "<C-o>zz")
-- map("<C-i>", "<C-i>zz")

-- make Y consistent with C and D
map("Y", "y$")

-- reselect after changing indentation
map("<", "<gv", {"v"})
map(">", ">gv", {"v"})

-- enable regex when searching
map("/", "/\\v", {"n", "v"})
map("?", "?\\v", {"n", "v"})

-- source current file
map("<leader>so", "<CMD>so %<CR>")

-- clear highlighted search
map("<leader><space>", "<CMD>noh<CR>")

-- remove trailing whitespace from file
map("<leader>ws", "<CMD>let _s=@/<Bar>:%s/\\s\\+$//e<Bar><CR><CMD>let @/=_s<Bar><CR>")

-- hex read/write
map("<leader>xr", "<CMD>%!xxd<CR><CMD>set filetype=xxd<CR>")
map("<leader>xw", "<CMD>%!xxd -r<CR><CMD>set binary<CR><CMD>filetype=<CR>")

-- open scratchpad files
map("<leader>spc", "<CMD>e ~/scratchpad/scratchpad.c<CR>")
map("<leader>spp", "<CMD>e ~/scratchpad/scratchpad.py<CR>")

-- Unmap annoying binds
map("<M-p>", "")
map("<M-n>", "")
map("<M-o>", "")
map("Q", "")

-- Diagnostics
map("<leader>dt", function() vim.diagnostic.config({virtual_lines = false, virtual_text = true}) end)
map("<leader>dl", function() vim.diagnostic.config({virtual_lines = true, virtual_text = false}) end)
map("<leader>dh", vim.diagnostic.hide)
map("<leader>ds", vim.diagnostic.show)
