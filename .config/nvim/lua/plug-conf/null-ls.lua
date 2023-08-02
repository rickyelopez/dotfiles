local null_ls = require("null-ls")

local black_config = {}
if vim.fn.expand("$BLACK_CFG") then
    black_config = {"--config", vim.fn.expand("$BLACK_CFG")}
end

require("null-ls").setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.black.with(black_config),
        null_ls.builtins.formatting.uncrustify,
        null_ls.builtins.formatting.yamlfmt,
    },
})
