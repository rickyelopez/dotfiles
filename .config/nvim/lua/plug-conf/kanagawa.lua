return {
  "rebelot/kanagawa.nvim",
  config = function()
    require("kanagawa").setup({
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = { italic = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      -- colors = {
      --     palette = {},
      --     theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      -- },
      -- overrides = function(colors) -- add/modify highlights
      --     return {}
      -- end,
      -- theme = "wave",
      -- background = {
      --     dark = "wave",
      --     light = "lotus"
      -- },
    })

    vim.cmd([[colorscheme kanagawa-wave]])
  end,
  enabled = false,
}
