local map = require("utils").map

vim.g.uncrustify_config_file = "$HOME/.config/uncrustify.cfg"

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"cpp", "c"},
    callback = function(ev)
        map("<leader>f", "<CMD>Uncrustify<CR>", "n", {noremap = true, silent = true, buffer = ev.buf})
        map("<leader>f", "<CMD>UncrustifyRange<CR>", "v", {noremap = true, silent = true, buffer = ev.buf})
    end,
})
