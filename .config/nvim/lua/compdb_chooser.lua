
require("telescope").register_extension {
  setup = function(topts)
    if #topts == 1 and topts[1] ~= nil then
      topts = topts[1]
    end

    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    local themes = require "telescope.themes"

    select_compiledb = function(opts)
        opts = opts or {}
        local find_command = { "rg", "--files"}--, "**compile_commands.json" }
        pickers.new(themes.get_dropdown{}, {
            prompt_title = "select compile_commands.json",
            finder = finders.new_oneshot_job(find_command, opts),
            sorter = conf.file_sorter(opts),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry().value
                    actions.close(prompt_bufnr)
                    Update_compiledb(selection)
                end)
                return true
            end,
        }):find()
    end
  end,
}
