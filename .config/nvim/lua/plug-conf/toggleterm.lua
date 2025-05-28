local map = require("utils").map

return {
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        float_opts = {
          border = "curved",
        },
        direction = "float",
        persist_mode = true,
        auto_scroll = false,
      })
      local tt = require("toggleterm")

      local function get_toggleterms()
        local bufnrs = vim.tbl_filter(function(b)
          return (vim.api.nvim_get_option_value("filetype", { buf = b }) == "toggleterm")
            and (vim.fn.getbufinfo(b)[1].variables.toggle_number < 10)
        end, vim.api.nvim_list_bufs())

        local toggle_numbers = vim.tbl_map(function(bufnr)
          return vim.fn.getbufinfo(bufnr)[1].variables.toggle_number
        end, bufnrs)

        return toggle_numbers
      end

      local function next_terminal()
        local terms = get_toggleterms()
        if #terms <= 1 then
          return
        end

        local current_term = vim.fn.getbufinfo("%")[1].variables.toggle_number
        local found = false

        for _, toggle_number in ipairs(terms) do
          if toggle_number > 10 then
            return
          end
          if (toggle_number ~= current_term) and found then
            tt.toggle(current_term)
            tt.toggle(toggle_number)
          elseif toggle_number == current_term then
            found = true
          end
        end
      end

      local function prev_terminal()
        local terms = get_toggleterms()
        if #terms <= 1 then
          return
        end

        local current_term = vim.fn.getbufinfo("%")[1].variables.toggle_number
        local to_toggle = current_term

        for _, toggle_number in ipairs(terms) do
          if (toggle_number == current_term) and (current_term ~= to_toggle) then
            tt.toggle(current_term)
            tt.toggle(to_toggle)
          elseif toggle_number ~= current_term then
            to_toggle = toggle_number
          end
        end
      end

      local Terminal = require("toggleterm.terminal").Terminal

      --- Keymaps that are common to TUI apps
      local function set_tui_keymaps(term)
        local opts = { noremap = true, silent = true, buffer = term.bufnr }
        vim.keymap.set("t", "<Esc>", "<Esc>", opts)
        vim.keymap.set("t", "q", "q", opts)
        vim.keymap.set("t", [[<C-\>]], "<CMD>close<CR>", opts)
      end

      local lazygit = Terminal:new({
        display_name = "lazygit",
        cmd = "lazygit",
        count = 10,
        hidden = true,
        direction = "float",
        on_open = set_tui_keymaps,
      })

      local file_browser = Terminal:new({
        display_name = "File Explorer",
        cmd = "yazi",
        count = 11,
        hidden = true,
        direction = "float",
        on_open = set_tui_keymaps,
      })

      local function set_terminal_keymaps()
        local opts = { noremap = true, silent = true, buffer = true }
        vim.keymap.set("t", "<Esc>", "<CMD>stopinsert<CR>", opts)
        vim.keymap.set("n", "gf", "<C-w>gF", opts)
        vim.keymap.set("n", "<S-Tab>", next_terminal, opts)
        vim.keymap.set("n", "<leader><S-Tab>", prev_terminal, opts)
      end

      -- use term://*toggleterm#* to apply to only toggleterm terminals
      -- use term://* for all terminals
      vim.api.nvim_create_autocmd({ "TermOpen" }, {
        pattern = { "term://*toggleterm#*" },
        callback = set_terminal_keymaps,
      })

      map("<leader>tl", function()
        lazygit:toggle()
      end)

      map("<leader>tf", function()
        file_browser:toggle()
      end)
    end,
  },
  {
    "da-moon/telescope-toggleterm.nvim",
    dependencies = "akinsho/toggleterm.nvim",
    keys = { "<leader>tt" },
    config = function()
      require("telescope-toggleterm").setup({
        telescope_mappings = {
          ["dd"] = require("telescope-toggleterm").actions.exit_terminal,
        },
      })
      map("<leader>tt", require("telescope").extensions.toggleterm.toggleterm)
    end,
  },
}
