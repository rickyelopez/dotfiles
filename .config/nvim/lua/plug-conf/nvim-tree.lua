return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>pv",
      function()
        require("nvim-tree.api").tree.open()
      end,
      mode = "n",
      silent = true,
      desc = "nvim-tree: Focus",
    },
    {
      "\\",
      function()
        require("nvim-tree.api").tree.find_file({
          open = true,
          update_root = true,
          focus = true,
        })
      end,
      mode = "n",
      silent = true,
      desc = "nvim-tree: Find file",
    },
  },
  opts = function()
    local map = require("utils").map
    local api = require("nvim-tree.api")

    local function on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.map.on_attach.default(bufnr)

      -- custom mappings
      map("<BS>", api.tree.change_root_to_parent, { "n" }, opts("Up"))
      map("?", api.tree.toggle_help, { "n" }, opts("Help"))
      map(".", api.tree.change_root_to_node, { "n" }, opts("CD"))
      map("C", api.node.navigate.parent_close, { "n" }, opts("Collapse"))
    end

    return {
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
      filesystem_watchers = {
        enable = false,
      },
      filters = {
        git_ignored = false,
        dotfiles = false,
      },
      git = {
        enable = false,
      },
    }
  end,
}
