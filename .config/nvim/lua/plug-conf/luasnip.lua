return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  config = function()
    -- from: https://github.com/tjdevries/config.nvim/blob/37c9356fd40a8d3589638c8d16a6a6b1274c40ca/lua/custom/snippets.lua
    local ls = require("luasnip")

    vim.snippet.expand = ls.lsp_expand

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.snippet.active = function(filter)
      filter = filter or {}
      filter.direction = filter.direction or 1

      if filter.direction == 1 then
        return ls.expand_or_jumpable()
      else
        return ls.jumpable(filter.direction)
      end
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.snippet.jump = function(direction)
      if direction == 1 then
        if ls.expandable() then
          return ls.expand_or_jump()
        else
          return ls.jumpable(1) and ls.jump(1)
        end
      else
        return ls.jumpable(-1) and ls.jump(-1)
      end
    end

    vim.snippet.stop = ls.unlink_current

    ls.config.setup({
      store_selection_keys = "<Tab>",
      keep_roots = true,
      link_roots = true,
      link_children = true,
      exit_roots = false,
      update_events = "TextChanged,TextChangedI",
      -- ext_opts = {},
    })

    ls.config.set_config({
      override_builtin = true,
    })

    require("luasnip.loaders.from_lua").lazy_load({ paths = { "./luasnippets/" } })

    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1)
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1)
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-u>", function()
      ls.change_choice(1)
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-y>", function()
      ls.change_choice(-1)
    end, { silent = true })
  end,
}
