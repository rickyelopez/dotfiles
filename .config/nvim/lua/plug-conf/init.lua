require("plugins")
require("impatient")

require("plug-conf.autopairs")
require("plug-conf.blamer")
-- require("plug-conf.uncrustify")
require("plug-conf.telescope")
require("plug-conf.bufferline")
require("plug-conf.neo-tree")
require("plug-conf.cmp")
require("plug-conf.treesitter")
require("plug-conf.lspconfig")
require("plug-conf.null-ls")
require("plug-conf.gitsigns")
require("plug-conf.toggleterm")

require("telescope-toggleterm").setup({
    telescope_mappings = {
        ["dd"] = require("telescope-toggleterm").actions.exit_terminal,
    },
})

-- if vim.env.BASE16_THEME and vim.g.colors_name ~= nil or vim.g.colors_name ~= "base16" .. vim.env.BASE16_THEME then
--     vim.cmd[[colorscheme "base16-" . vim.env.BASE16_THEME]]
-- end

require("plug-conf.tokyonight")
-- require("plug-conf.kanagawa")
require("plug-conf.lualine")

require("plug-conf.misc")

require("colorizer").setup()
