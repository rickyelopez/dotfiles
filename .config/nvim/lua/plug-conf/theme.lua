return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    dependencies = "chriskempson/base16-vim",
    config = function()
      require("tokyonight").setup({
        style = "moon",
        light_style = "day",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = { italic = true },
          variables = {},
          sidebars = "dark",
          floats = "moon",
        },
        day_brightness = 0.3,
        dim_inactive = false,
        lualine_bold = false,
        plugins = {
          auto = true,
        },
      })

      vim.cmd([[colorscheme tokyonight]])

      vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#00005f" })
      vim.api.nvim_set_hl(0, "LineNr", { fg = "lightyellow" })

      -- tokens
      vim.api.nvim_set_hl(0, "@lsp.type.comment", { link = "@comment" })
      vim.api.nvim_set_hl(0, "@lsp.typemod.variable.fileScope", { link = "Bold" })
      vim.api.nvim_set_hl(0, "@lsp.typemod.variable.readonly", { link = "Underlined" })
      vim.api.nvim_set_hl(0, "@lsp.typemod.variable.functionScope", { fg = "#468a6d" })
      vim.api.nvim_set_hl(0, "@lsp.typemod.variable.local", { fg = "#468a6d" })
      vim.api.nvim_set_hl(0, "@lsp.typemod.variable.globalScope", { fg = "#b9675d" })
    end,
  },
}
