return {
  "akinsho/nvim-bufferline.lua",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    local cycle = require("bufferline").cycle

    local M = {}

    -- local contrast_color = "#363955"
    -- local selected_color = "#243622"
    -- "#222436",

    require("bufferline").setup({
      -- highlights = {
      --   fill = {
      --     bg = contrast_color,
      --   },
      --   buffer_selected = {
      --     bg = selected_color,
      --   },
      --   info_selected = {
      --     bg = selected_color,
      --   },
      --   info_diagnostic_selected = {
      --     bg = selected_color,
      --   },
      --   separator = {
      --     fg = contrast_color,
      --   },
      --   separator_visible = {
      --     fg = contrast_color,
      --   },
      --   separator_selected = {
      --     fg = contrast_color,
      --     bg = selected_color,
      --   },
      -- },
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
            {
              name = "DB",
              priority = 3,
              matcher = function(buf)
                return buf.path:match(vim.env.di .. "/DB")
              end,
            },
            {
              name = "DI",
              priority = 4,
              matcher = function(buf)
                return buf.path:match(vim.env.dig3 .. "/controller") or buf.path:match(vim.env.di .. "/DI")
              end,
            },
            {
              name = "PM",
              priority = 5,
              matcher = function(buf)
                return buf.path:match(vim.env.dig3 .. "/monitor") or buf.path:match(vim.env.di .. "/PM")
              end,
            },
            {
              name = "DIVAL",
              priority = 6,
              matcher = function(buf)
                return buf.path:match(vim.env.di .. "/dival")
              end,
            },
            {
              name = "DI Gen",
              priority = 2,
              matcher = function(buf)
                return buf.path:match(vim.env.di)
                  and not (
                    buf.path:match(vim.env.di .. "/DB")
                    or buf.path:match(vim.env.dig3 .. "/controller")
                    or buf.path:match(vim.env.di .. "/DI")
                    or buf.path:match(vim.env.dig3 .. "/monitor")
                    or buf.path:match(vim.env.di .. "/PM")
                    or buf.path:match(vim.env.di .. "/dival")
                  )
              end,
            },
            {
              name = "EGG",
              matcher = function(buf)
                return buf.path:match("components/egg")
              end,
            },
            {
              name = "CAN",
              matcher = function(buf)
                return buf.path:match("can.requirements")
              end,
            },
            {
              name = "DBC",
              matcher = function(buf)
                return buf.path:match("generated.dbc")
              end,
            },
            {
              name = "HV",
              matcher = function(buf)
                return buf.path:match("hvSystem")
              end,
            },
          },
        },
      },
    })

    M.close = function(buf)
      if buf == 0 then
        buf = vim.api.nvim_get_current_buf()
      end
      local current = vim.api.nvim_buf_get_name(0)
      local arg = vim.api.nvim_buf_get_name(buf)

      -- if closing a buffer we don't have selected, there are no issues
      if current ~= arg then
        vim.api.nvim_buf_delete(buf, {})
        return
      end

      local last = vim.fn.bufnr("#")
      if vim.api.nvim_buf_is_valid(last) then
        -- vim.fn.buffer(last)
        vim.api.nvim_exec(":buffer " .. last, false)
      elseif #vim.api.nvim_list_bufs() > 1 then
        cycle(-1)
      else
        local newBuf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_exec(":buffer " .. newBuf, false)
      end
      vim.api.nvim_buf_delete(buf, {})
    end

    -- Keymaps
    local map = require("utils").map

    map("<leader>q", function()
      M.close(0)
    end)
    map("<S-Tab>", "<CMD>BufferLineCycleNext<CR>")
    map("<leader><S-Tab>", "<CMD>BufferLineCyclePrev<CR>")
    map("<leader><S-L>", "<CMD>BufferLineMoveNext<CR>")
    map("<leader><S-H>", "<CMD>BufferLineMovePrev<CR>")
    map("gb", "<CMD>BufferLinePick<CR>")
  end,
}
