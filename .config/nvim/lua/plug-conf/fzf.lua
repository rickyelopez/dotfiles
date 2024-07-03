return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      { "junegunn/fzf", build = "./install --bin" },
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local fzf_lua = require("fzf-lua")
      local actions = require("fzf-lua.actions")
      local map = require("utils").map

      local ignores = {
        ".git",
        ".cache",
        ".msr",
        ".gvl",
        ".map",
        ".asm",
        ".pyc",
        ".png",
        ".o",
        ".asms",
        ".asmss",
        ".c.html",
        ".compact.json",
        ".json.raw",
        ".html",
      }

      local fd_ignore = "--no-ignore"
      local rg_ignore = "--no-ignore"

      for _, ignore in ipairs(ignores) do
        fd_ignore = fd_ignore .. " --exclude " .. ignore
        rg_ignore = rg_ignore .. " --glob '!" .. ignore .. "'"
      end

      fzf_lua.register_ui_select()

      fzf_lua.setup({
        git_icons = false,
        winopts = {
          height = 0.9, -- window height
          width = 0.9, -- window width
          preview = {
            default = "bat", -- override the default previewer
            horizontal = "right:50%", -- right|left:size
          },
        },
        files = {
          toggle_ignore_flag = "--no-ignore " .. fd_ignore,
        },
        grep = {
          toggle_ignore_flag = "--no-ignore " .. rg_ignore,
          actions = {
            ["ctrl-g"] = { actions.toggle_ignore },
          },
        },
      })

      map("<C-p>", fzf_lua.files)
      map("<leader>gg", fzf_lua.live_grep)
      map("<leader>gw", fzf_lua.grep_cword) -- in normal mode, search word under cursor
      map("<leader>gw", fzf_lua.grep_visual, { "v" }) -- in visual mode, search the selection
      map("<leader>gr", fzf_lua.resume) -- in visual mode, search the selection
    end,
  },
}
