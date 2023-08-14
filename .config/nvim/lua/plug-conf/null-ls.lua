local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting

local black_config = vim.env.BLACK_CFG and { "--config", vim.env.BLACK_CFG } or {}

null_ls.setup({
  debug = true,
  sources = {
    formatting.stylua,
    formatting.black.with(black_config),
    formatting.yamlfmt,
  },
})
