require("plug-conf.telescope")
require("plug-conf.bufferline")
require("plug-conf.neo-tree")
require("plug-conf.cmp")
require("plug-conf.treesitter")
require("plug-conf.lspconfig")
require("plug-conf.null-ls")
require("plug-conf.gitsigns")
require("plug-conf.toggleterm")
require("telescope-toggleterm").setup {
   telescope_mappings = {
      ["dd"] = require("telescope-toggleterm").actions.exit_terminal,
   },
}

require("plug-conf.tokyonight")
require("plug-conf.airline")


-- require("utils")
require("binds")
