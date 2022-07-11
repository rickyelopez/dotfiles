local pickers = require "telescope.pickers"
local finders = require("telescope.finders")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local themes = require('telescope.themes')
local previewers = require("telescope.previewers")

require("telescope").setup({
    defaults = {
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        prompt_prefix = "",
        color_devicons = true,

        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            },
        },
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
    },
})

require("telescope").load_extension("fzy_native")

local MyFunctions = {
    search_dotfiles = function()
        require("telescope.builtin").find_files({
            find_command = {"rg", "--files", "--hidden", "--no-ignore-vcs"},
            prompt_title = "< VimRC >",
            cwd = "$HOME/.config/nvim",
            hidden = true,
        })
    end,

    select_compiledb = function(opts)
        opts = opts or {}
        local find_command = { "rg", "--files", "--no-ignore-vcs", "-g", "*compile_commands.json" }
        pickers.new(themes.get_dropdown{ layout_config = {width = 0.8} }, {
            prompt_title = "Select compile_commands.json",
            finder = finders.new_oneshot_job(find_command, opts),
            sorter = conf.file_sorter(opts),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry().value
                    actions.close(prompt_bufnr)
                    vim.fn.Update_compiledb(selection)
                end)
                return true
            end,
        }):find()
    end,
}

return MyFunctions
