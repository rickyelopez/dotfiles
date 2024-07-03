return {
  "akinsho/bufferline.nvim",
  -- "git@github.com:rickyelopez/bufferline.nvim",
  -- branch = "user/rl/groupDuplicates",
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
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 5,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          return "(" .. count .. ")"
        end,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = false,
        persist_buffer_sort = true,
        enforce_regular_tabs = false,
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
            },
          },
        },
      },
    })

    --- @param buf integer buffer number, or 0 for current buffer
    M.close = function(buf)
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
        local newBuf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_set_current_buf(newBuf)
      end
      vim.api.nvim_buf_delete(buf, {})
    end

    -- Keymaps
    local map = require("utils").map

    map("<leader>q", function()
      M.close(0)
    end)
    map("<S-Tab>", function() cycle(1) end)
    map("<leader><S-Tab>", function() cycle(-1) end)
    map("<leader><S-L>", function() move(1) end)
    map("<leader><S-H>", function() move(-1) end)
    map("gb", pick)
  end,
}
