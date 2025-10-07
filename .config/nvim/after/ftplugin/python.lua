--- from: https://github.com/aikow/dotfiles/blob/main/config/nvim/after/ftplugin/python.lua

vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smarttab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.textwidth = 120

-- Set the indent after opening parenthesis
vim.g.pyindent_open_paren = vim.bo.shiftwidth

-- ------------------------------------------------------------------------
-- | MiniAI
-- ------------------------------------------------------------------------

-- local spec_treesitter = require("mini.ai").gen_spec.treesitter
-- vim.b.miniai_config = {
--   custom_textobjects = {
--     t = spec_treesitter({ a = "@annotation.outer", i = "@annotation.outer" }),
--   },
-- }

-- ------------------------------------------------------------------------
-- | Keymaps
-- ------------------------------------------------------------------------

-- vim.keymap.set(
--   { "n", "x" },
--   "<localleader>r",
--   [[:!python3 %<CR>]],
--   { buffer = true, desc = "Run the file or region through the interpreter" }
-- )

-- vim.keymap.set(
--   "n",
--   "<localleader>l",
--   "<cmd>cexpr(system('ruff check --output-format=concise'))<cr>",
--   { buffer = true, desc = "populate the quickfix list with the output of 'ruff check'" }
-- )

-- vim.keymap.set(
--   { "n", "x" },
--   "<localleader>fr",
--   function()
--     require("conform").format({
--       async = true,
--       lsp_fallback = true,
--       formatters = { "ruff_fix" },
--     })
--   end,
--   { buffer = true, desc = "Format the current buffer by fixing all lints using ruff" }
-- )
