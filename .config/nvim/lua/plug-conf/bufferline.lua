require('bufferline').setup {
  options = {
    close_command = "buffer #|bd %d",       -- can be a string | function, see "Mouse actions"
    right_mouse_command = "buffer %d|bp|bd #", -- can be a string | function, see "Mouse actions"
    left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
    --- name_formatter can be used to change the buffer's label in the bufferline.
    --- Please note some names can/will break the
    --- bufferline so use this at your discretion knowing that it has
    --- some limitations that will *NOT* be fixed.
    name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
      -- remove extension from markdown files for example
      -- if buf.name:match('%.md') then
      --   return vim.fn.fnamemodify(buf.name, ':t:r')
      -- end
    end,
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    tab_size = 18,
    diagnostics = "coc",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      return "("..count..")"
    end,
    -- NOTE: this will be called a lot so don't do any heavy processing here
    custom_filter = function(buf_number)
      -- filter out filetypes you don't want to see
      -- if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
      --   return true
      -- end
      -- filter out by buffer name
      -- if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
      --   return true
      -- end
      -- filter out based on arbitrary rules
      -- e.g. filter out vim wiki buffer from tabline in your work repo
      -- if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
      --   return true
      -- end
      return true
    end,
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = false,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- enforce_regular_tabs = false | true,
    -- always_show_bufferline = true | false,
    -- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
    -- add custom logic
    -- return buffer_a.modified > buffer_b.modified
    -- end
    separator_style = "thick",
    groups = {
      options = {
        toggle_hidden_on_enter = true -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
      },
      items = {
        {
          name = "Configs",
          highlight = {gui = "undercurl", guisp = "purple"}, -- Optional
          matcher = function(buf) -- Mandatory
            return buf.path:match('dotfiles') or buf.path:match('~/.config')
          end,
        },
        {
          name = "DI",
          highlight = {gui = "undercurl", guisp = "green"}, -- Optional
          matcher = function(buf) -- Mandatory
            return buf.path:match('driveInverter/gen3/controller')
          end,
        },
        {
          name = "PM",
          highlight = {gui = "undercurl", guisp = "cyan"},
          matcher = function(buf)
            return buf.path:match('driveInverter/gen3/monitor')
          end,
        },
        {
          name = "DIVAL",
          highlight = {gui = "undercurl", guisp = "orange"}, -- Optional
          matcher = function(buf) -- Mandatory
            return buf.path:match('dival')
          end,
        },
        {
          name = "CAN",
          highlight = {gui = "undercurl", guisp = "yellow"}, -- Optional
          matcher = function(buf) -- Mandatory
            return buf.path:match('can.requirements')
          end,
        },
        {
          name = "DBC",
          highlight = {gui = "undercurl", guisp = "orange"}, -- Optional
          matcher = function(buf) -- Mandatory
            return buf.path:match('generated.dbc')
          end,
        },
        {
          name = "HV",
          highlight = {gui = "undercurl", guisp = "red"}, -- Optional
          matcher = function(buf) -- Mandatory
            return buf.path:match('hvSystem')
          end,
        },
        {
          name = "DI Gen",
          highlight = {gui = "undercurl", guisp = "green"}, -- Optional
          matcher = function(buf) -- Mandatory
            return buf.path:match('driveInverter')
          end,
        },
      }
    }
  }
}
