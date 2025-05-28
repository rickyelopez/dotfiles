return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    "<leader>pv",
    "\\",
  },
  config = function()
    local map = require("utils").map
    local api = require("nvim-tree.api")

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, noremap = true, silent = true, nowait = true }
    end

    map("<leader>pv", api.tree.focus, { "n" }, opts("Focus"))
    map([[\]], function()
      api.tree.find_file({ open = true, focus = true, update_root = true })
    end, { "n" }, opts("Find file"))

    local function on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      map("<BS>", api.tree.change_root_to_parent, { "n" }, opts("Up"))
      map("?", api.tree.toggle_help, { "n" }, opts("Help"))
      map(".", api.tree.change_root_to_node, { "n" }, opts("CD"))
      map("C", api.node.navigate.parent_close, { "n" }, opts("Collapse"))
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
    })
  end,
}
