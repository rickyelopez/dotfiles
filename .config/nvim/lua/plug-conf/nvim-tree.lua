return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    local map = require("utils").map
    local api = require("nvim-tree.api")

    map("<leader>pv", api.tree.focus)
    map([[\]], function() api.tree.find_file(); api.tree.focus() end)

    local function on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set("n", "<BS>", api.tree.change_root_to_parent, opts("Up"))
      vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
      vim.keymap.set("n", ".", api.tree.change_root_to_node, opts("CD"))
      vim.keymap.set("n", "C", api.node.navigate.parent_close, opts("Collapse"))
    end

    require("nvim-tree").setup({
      on_attach = on_attach,
      sort_by = "case_sensitive",
      -- sync_root_with_cwd = true,
      actions = {
        change_dir = {
          enable = true,
          global = true,
        },
      },
      view = {
        width = {
          min = 30,
          max = 50,
        },
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        git_ignored = false,
        dotfiles = false,
      },
      git = {
        enable = false,
       }
    })
  end,
}
