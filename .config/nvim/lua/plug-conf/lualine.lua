return {
  "nvim-lualine/lualine.nvim",
  dependencies = "RRethy/nvim-base16",
  config = function()
    require("lualine").setup({
      options = {
        -- theme = "base16",
        globalstatus = true,
      },
      sections = {
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
      },
    })
  end,
}
