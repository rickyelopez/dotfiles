return {
  "nvimdev/lspsaga.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  event = "LspAttach",
  config = function()
    require("lspsaga").setup({
      lightbulb = {
        virtual_text = false,
      },
      code_action = {
        show_server_name = true,
      },
    })

    local map = require("utils").map
    map("<leader>ca", function()
      require("lspsaga.codeaction"):code_action()
    end)
  end,
}
