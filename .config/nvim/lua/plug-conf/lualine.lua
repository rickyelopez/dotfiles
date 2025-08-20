return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local function progress_lines()
      local cur = vim.fn.line(".")
      local total = vim.fn.line("$")
      return "" .. cur .. "/" .. total
    end

    local function recording()
      local reg = vim.fn.reg_recording()
      if reg == "" then
        return ""
      end
      return "Rec: " .. reg
    end

    vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
      callback = function()
        require("lualine").refresh()
      end,
    })

    require("lualine").setup({
      options = {
        theme = "tokyonight",
        globalstatus = false,
      },
      extensions = {
        "fzf",
        "lazy",
        "man",
        "mason",
        "nvim-tree",
        "quickfix",
        "toggleterm",
        "trouble",
      },
      sections = {
        lualine_a = { "mode", recording },
        lualine_b = { "diagnostics" },
        lualine_c = {
          {
            "filename",
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
        lualine_x = { "encoding", "fileformat", "filetype", "lsp_status" },
        lualine_y = {
          { "searchcount", maxcount = 999, timeout = 500 },
          "selectioncount",
          progress_lines,
        },
      },
      inactive_sections = {
        lualine_c = {
          {
            "filename",
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
        lualine_x = { "location" },
      },
    })
  end,
}
