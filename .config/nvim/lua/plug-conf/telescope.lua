return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzy-native.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local action_state = require("telescope.actions.state")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local themes = require("telescope.themes")
    local previewers = require("telescope.previewers")
    local builtin = require("telescope.builtin")

    require("telescope").setup({
      defaults = {
        prompt_prefix = "🔍 ",
        color_devicons = true,

        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,

        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
        file_ignore_patterns = {
          "%.git/",
          "/%.cache/",
          "%.msr",
          "%.gvl",
          "%.map",
          "%.asm",
          "%.asms",
          "%.pyc",
          "%.png",
          "%.c%.html",
          "%.compact%.json",
          "%.json%.raw",
        },

        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<C-u>"] = actions.results_scrolling_up,
            ["<C-d>"] = actions.results_scrolling_down,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-n>"] = actions.cycle_history_next,
            ["<PageUp>"] = actions.preview_scrolling_up,
            ["<PageDown>"] = actions.preview_scrolling_down,
          },
          n = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<C-u>"] = actions.results_scrolling_up,
            ["<C-d>"] = actions.results_scrolling_down,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-n>"] = actions.cycle_history_next,
            ["<PageUp>"] = actions.preview_scrolling_up,
            ["<PageDown>"] = actions.preview_scrolling_down,
            ["dd"] = actions.delete_buffer,
          },
        },
      },
      pickers = {
        live_grep = {
          path_display = {
            shorten = {
              len = 4,
              exclude = { 2, 3, -1, -2 },
            },
          },
        },
        find_files = {
          path_display = {
            shorten = {
              len = 4,
              exclude = { 3, 4, -1, -2 },
            },
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    require("telescope").load_extension("fzf")
    require("telescope").load_extension("toggleterm")

    local M = {}

    function M.search_dotfiles()
      builtin.find_files({
        find_command = { "fd", "--hidden", "--type", "file" },
        prompt_title = "< dotfiles >",
        cwd = "$HOME",
        search_dirs = { "$HOME/dotfiles", "$HOME/dotfiles_priv" },
        hidden = true,
      })
    end

    function M.select_compiledb(opts)
      opts = opts or {}
      local find_command = { "fd", "--type", "file", "--no-ignore-vcs", "-g", "*compile_commands.json" }
      pickers
        .new(themes.get_dropdown({ layout_config = { width = 0.6 } }), {
          prompt_title = "Select compile_commands.json",
          finder = finders.new_oneshot_job(find_command, opts),
          sorter = conf.file_sorter(opts),
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry().value
              actions.close(prompt_bufnr)
              vim.system({ "ln", "-sf", vim.fn.getcwd() .. selection })
              vim.notify("Linked compile commands file")
            end)
            return true
          end,
        })
        :find()
    end

    function M.workspace_folders(opts)
      opts = opts or {}

      local buf = vim.fn.bufnr("%")

      local function get_folders()
        return vim.api.nvim_buf_call(buf, function()
          return vim.lsp.buf.list_workspace_folders()
        end)
      end

      if #get_folders() == 0 then
        vim.notify("No folders in workspace")
        return
      end

      local function remove_folder(folder)
        vim.api.nvim_buf_call(buf, function()
          vim.lsp.buf.remove_workspace_folder(folder)
        end)
      end

      pickers
        .new(themes.get_dropdown({ layout_config = { width = 0.6 } }), {
          prompt_title = "LSP Workspace Folders",
          finder = finders.new_dynamic({
            fn = get_folders,
          }),
          sorter = conf.file_sorter(opts),
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function() end)
            actions.delete_buffer:replace(function()
              local selection = action_state.get_selected_entry().value
              remove_folder(selection)
              vim.notify("Removed " .. selection .. " from LSP workspace")

              local picker = action_state.get_current_picker(prompt_bufnr)
              picker:refresh()
            end)
            return true
          end,
        })
        :find()
    end

    -- Keymaps
    local map = require("utils").map

    map("<leader>tg", function()
      local additional_args = {}

      -- local neotree_state = require("neo-tree.sources.manager").get_state("filesystem")
      -- local curr_buf = vim.api.nvim_get_current_buf()
      -- local buf = neotree_state.bufnr
      -- local path = neotree_state.path
      -- if buf == curr_buf then
      --     additional_args = {"-g", path .. "/**/*"}
      --     print(vim.inspect(additional_args))
      -- end

      return builtin.live_grep({
        additional_args = function()
          if vim.g.grep_ignore ~= "" then
            table.insert(additional_args, "--no-ignore-vcs")
          end
          return additional_args
        end,
      })
    end)

    map("<leader>tp", function()
      return builtin.find_files({
        find_command = function()
          local cmd = { "fd", "--hidden", "--type", "file" }
          if vim.g.grep_ignore ~= "" then
            table.insert(cmd, "--no-ignore-vcs")
            return cmd
          end
          return cmd
        end,
      })
    end)

    map("<leader>tw", builtin.grep_string)
    map("<leader>bf", builtin.buffers)
    map("<leader>vh", builtin.help_tags)
    map("<leader>m", builtin.marks)
    map("<leader>ts", builtin.treesitter)
    map("<leader>vrc", M.search_dotfiles)
    map("<leader>cc", M.select_compiledb)

    map("<leader>wl", M.workspace_folders)

    return M
  end,
}
