return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
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
      local lazygit = Terminal:new({
        cmd = "lazygit",
        count = 10,
        hidden = true,
        direction = "float",
        on_open = function(term)
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", "q", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", [[<C-\>]], [[<cmd>close<CR>]], { noremap = true, silent = true })
        end,
      })

      function _G.set_terminal_keymaps()
        -- local opts = {buffer = 0}
        -- vim.keymap.set('t', 'q', [[<C-\><C-n>]], opts)
        -- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        -- vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        -- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        -- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        -- vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      -- use term://*toggleterm#* to apply to only toggleterm terminals
      -- use term://* for all terminals
      vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

      local map = require("utils").map
      map("<leader>tl", function()
        lazygit:toggle()
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
