return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local cycle = require("bufferline").cycle
    local move = require("bufferline").move
    local pick = require("bufferline").pick
    local utils = require("utils")

    local M = {}

    require("bufferline").setup({
      options = {
        close_command = M.close,
        right_mouse_command = M.close,
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        max_name_length = 30,
        max_prefix_length = 15,
        tab_size = 5,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          return "(" .. count .. ")"
        end,
        custom_filter = function(buf_number, buf_numbers)
          -- filter out filetypes you don't want to see
          -- if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
          --     return true
          -- end
          -- filter out by buffer name
          if vim.fn.bufname(buf_number) ~= "health://" then
              return true
          end
          -- filter out based on arbitrary rules
          -- e.g. filter out vim wiki buffer from tabline in your work repo
          -- if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
          --     return true
          -- end
          return false
        end,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = false,
        persist_buffer_sort = true,
        enforce_regular_tabs = false,
        hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
        },
        sort_by = "relative_directory",
        separator_style = "slant",
        duplicates_across_groups = false,
        groups = {
          options = {
            toggle_hidden_on_enter = true,
          },
          items = {
            {
              name = "Configs",
              priority = 1,
              matcher = function(buf)
                return buf.path:match("dotfiles") or buf.path:match("%.config")
              end,
              auto_close = false,
            },
          },
        },
      },
    })

    --- @param buf integer buffer number, or 0 for current buffer
    function M.close(buf)
      if buf == 0 then
        buf = vim.fn.bufnr("%")
      end

      -- if closing a buffer we don't have selected, there are no issues
      if buf ~= vim.api.nvim_get_current_buf() then
        vim.api.nvim_buf_delete(buf, {})
        return
      end

      local last = vim.fn.bufnr("#")
      if vim.api.nvim_buf_is_valid(last) then
        vim.api.nvim_set_current_buf(last)
      elseif #utils.listValidBuffers() > 1 then
        cycle(-1)
      else
        local newBuf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_set_current_buf(newBuf)
      end
      vim.api.nvim_buf_delete(buf, {})
    end

    -- Keymaps
    local map = require("utils").map

    map("<leader>q", function()
      M.close(0)
    end)
    map("<S-Tab>", function()
      cycle(1)
    end)
    map("<leader><S-Tab>", function()
      cycle(-1)
    end)
    map("<leader><S-L>", function()
      move(1)
    end)
    map("<leader><S-H>", function()
      move(-1)
    end)
    map("gb", pick)
  end,
}
