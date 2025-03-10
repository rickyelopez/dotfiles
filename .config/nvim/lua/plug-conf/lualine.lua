return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local function progress_lines()
      local cur = vim.fn.line(".")
      local total = vim.fn.line("$")
      return "" .. cur .. "/" .. total
    end
    require("lualine").setup({
      options = {
        theme = "tokyonight",
        globalstatus = true,
      },
      extensions = { "fzf", "lazy", "man", "mason", "nvim-tree", "oil", "toggleterm" },
      sections = {
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
        lualine_y = {
          progress_lines
        },
      },
    })
  end,
}
