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
    local fzf = require("fzf-lua")
    local api = require("nvim-tree.api")

    local function get_dir(opts)
      local node = api.tree.get_node_under_cursor()
      if node == nil then
        vim.notify("tried to get node, got nil", vim.log.levels.ERROR)
        return nil
      end

      local basedir = node.type == "directory" and node.absolute_path or vim.fs.dirname(node.absolute_path)
      vim.notify(basedir)
      opts = opts or {}
      opts.cwd = basedir
      opts.search_dirs = { basedir }
      -- opts.attach_mappings = view_selection
      return opts
    end

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

      map("<leader>gg", function()
        fzf.live_grep(get_dir())
      end, { "n" }, opts("Live grep in currently highlighted dir"))

      map("<C-p>", function()
        fzf.files(get_dir())
      end, { "n" }, opts("Files in currently highlighted dir"))
    end

    return {
      on_attach = on_attach,
      sort = {
        sorter = "case_sensitive",
      },
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
