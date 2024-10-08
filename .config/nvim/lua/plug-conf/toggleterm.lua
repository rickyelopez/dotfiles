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

      local Terminal = require("toggleterm.terminal").Terminal

      --- Keymaps that are common to TUI apps
      local function set_tui_keymaps(term)
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", "<Esc>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", "q", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", [[<C-\>]], [[<cmd>close<CR>]], { noremap = true, silent = true })
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
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", [[<Cmd>stopinsert<CR>]], opts)
        vim.api.nvim_buf_set_keymap(0, "n", "gf", [[<C-w>gF]], opts)
        -- vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", [[<C-\><C-n>]], opts)
        -- vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
        -- vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        -- vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        -- vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        -- vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      end

      -- use term://*toggleterm#* to apply to only toggleterm terminals
      -- use term://* for all terminals
      -- vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
      vim.api.nvim_create_autocmd({ "TermOpen" }, {
        pattern = { "term://*toggleterm#*" },
        callback = set_terminal_keymaps,
      })

      local map = require("utils").map

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
    config = function()
      require("telescope-toggleterm").setup({
        telescope_mappings = {
          ["dd"] = require("telescope-toggleterm").actions.exit_terminal,
        },
      })
    end,
  },
}
