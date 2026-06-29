return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      { "junegunn/fzf", build = "./install --bin" },
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local fzf_lua = require("fzf-lua")
      local actions = fzf_lua.actions
      local map = require("utils").map

      local ignores = {
        ".asm",
        ".asms",
        ".asmss",
        ".c.html",
        ".cache",
        ".compact.json",
        ".git",
        ".gvl",
        ".html",
        ".json.raw",
        ".map",
        ".msr",
        ".o",
        ".png",
        ".pyc",
      }

      local fd_ignore = "--no-ignore"
      local rg_ignore = "--no-ignore"

      for _, ignore in ipairs(ignores) do
        fd_ignore = fd_ignore .. " --exclude " .. ignore
        rg_ignore = rg_ignore .. " --glob '!" .. ignore .. "'"
      end

      fzf_lua.register_ui_select()

      fzf_lua.setup({
        winopts = {
          height = 0.9, -- window height
          width = 0.9, -- window width
          preview = {
            default = "bat", -- override the default previewer
            horizontal = "right:50%", -- right|left:size
          },
        },
        keymap = {
          builting = {
            ["<M-Esc>"] = "hide",
          },
          fzf = {
            ["ctrl-u"] = "page-up",
            ["ctrl-d"] = "page-down",
          },
        },
        files = {
          git_icons = false,
          toggle_ignore_flag = "--no-ignore " .. fd_ignore,
          actions = {
            ["ctrl-g"] = { actions.toggle_ignore },
          },
        },
        grep = {
          git_icons = false,
          rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
          toggle_ignore_flag = "--no-ignore " .. rg_ignore,
          actions = {
            ["ctrl-g"] = { actions.toggle_ignore },
          },
        },
      })

      -- reimplement grep_cword and grep_visual from fzf-lua to use live_grep instead of grep
      local function grep_cword(opts)
        opts = opts or {}
        opts.no_esc = true
        -- match whole words only (#968)
        opts.search = fzf_lua.utils.rg_escape_cword(vim.fn.expand("<cword>"))
        return fzf_lua.live_grep(opts)
      end

      local function grep_visual(opts)
        opts = opts or {}
        opts.search = fzf_lua.utils.get_visual_selection()
        return fzf_lua.live_grep(opts)
      end

      map("<C-p>", fzf_lua.files)
      map("<leader>cd", function()
        fzf_lua.files({
          cmd_raw = "fd",
          fd_opts = [[--color=never --hidden --type d --exclude .git]],
          previewer = "hidden",
          winopts = { title = "Choose Directory" },
        })
      end)
      map("<leader>gg", fzf_lua.live_grep)
      map("<leader>gw", grep_cword) -- in normal mode, search word under cursor
      map("<leader>gw", grep_visual, { "v" }) -- in visual mode, search the selection
      map("<leader>gr", fzf_lua.resume) -- resume previous grep/fd search
    end,
  },
}
