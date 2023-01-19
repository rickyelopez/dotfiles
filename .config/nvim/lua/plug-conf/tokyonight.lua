require("tokyonight").setup({
  style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  light_style = "day", -- The theme is used when the background is set to light
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = { italic = true },
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "moon", -- style for sidebars, see below
    floats = "moon", -- style for floating windows
  },
  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  -- on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  -- on_highlights = function(highlights, colors) end,
})

vim.cmd[[colorscheme tokyonight]]

vim.api.nvim_set_hl(0, "ColorColumn", {cterm=NONE, bg = "#00005f"})
vim.api.nvim_set_hl(0, "LineNr", {fg = "lightyellow"})

-- -- tokens
-- vim.api.nvim_set_hl(0, "LspInactiveCode", {link = "@comment"})
vim.api.nvim_set_hl(0, "LspComment", {link = "@comment"})
vim.api.nvim_set_hl(0, "LspFileVariable", {link = "Bold"})
vim.api.nvim_set_hl(0, "LspReadonlyVariable", {link = "Underlined"})
vim.api.nvim_set_hl(0, "LspParameter", {link = "@parameter"})
-- vim.api.nvim_set_hl(0, "LspReadonlyClass", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspReadonlyStatic", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspVariable", {link = "@variable"})
-- vim.api.nvim_set_hl(0, "LspNamespace", {link = "@namespace"})
-- vim.api.nvim_set_hl(0, "LspType", {link = "@type"})
-- vim.api.nvim_set_hl(0, "LspClass", {link = "@type.definition"})
-- vim.api.nvim_set_hl(0, "LspEnum", {link = "@type"})
-- vim.api.nvim_set_hl(0, "LspInterface", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspStruct", {link = "@type"})
-- vim.api.nvim_set_hl(0, "LspTypeParameter", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspProperty", {link = "@property"})
-- vim.api.nvim_set_hl(0, "LspEnumMember", {link = "@field"})
-- vim.api.nvim_set_hl(0, "LspEvent", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspFunction", {link = "@function"})
-- vim.api.nvim_set_hl(0, "LspMethod", {link = "@method"})
-- vim.api.nvim_set_hl(0, "LspMacro", {link = "@preproc"})
-- vim.api.nvim_set_hl(0, "LspKeyword", {link = "@keyword"})
-- vim.api.nvim_set_hl(0, "LspModifier", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspString", {link = "@string"})
-- vim.api.nvim_set_hl(0, "LspNumber", {link = "@number"})
-- vim.api.nvim_set_hl(0, "LspRegexp", {link = "@string.regex"})
-- vim.api.nvim_set_hl(0, "LspOperator", {link = "@operator"})
-- vim.api.nvim_set_hl(0, "LspDecorator", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspGlobalVariable", {link = "@comment"})

-- -- modifiers
-- vim.api.nvim_set_hl(0, "LspDeclaration", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspDefinition", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspReadonly", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspStatic", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspDeprecated", {link = "@text.warning"})
-- vim.api.nvim_set_hl(0, "LspAbstract", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspAsync", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspModification", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspDocumentation", {link = "@comment"})
-- vim.api.nvim_set_hl(0, "LspDefaultLibrary", {link = "@function.builtin"})
-- vim.api.nvim_set_hl(0, "LspGlobalScope", {link = "@comment"})
