return {
  "cameron-wags/rainbow_csv.nvim",
  config = function()
    local rainbow  = require("rainbow_csv")
    vim.g.disable_rainbow_hover = 1
    rainbow.setup()
  end,
  ft = {
    "csv",
    "tsv",
    "csv_semicolon",
    "csv_whitespace",
    "csv_pipe",
    "rfc_csv",
    "rfc_semicolon",
  },
  cmd = {
    "RainbowDelim",
    "RainbowDelimSimple",
    "RainbowDelimQuoted",
    "RainbowMultiDelim",
  },
}
