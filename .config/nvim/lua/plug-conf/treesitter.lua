return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()
      ts.install({
        "bash",
        "c",
        "cpp",
        "css",
        "gn",
        "html",
        "javascript",
        "just",
        "lua",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "query",
        "rust",
        "starlark",
        "sql",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "zig",
      })

      -- https://github.com/nvim-treesitter/nvim-treesitter/discussions/8546#discussioncomment-16441482
      local function is_parser_installed(lang)
        local installed = require("nvim-treesitter").get_installed()
        return vim.tbl_contains(installed, lang)
      end

      local function is_parser_available(lang)
        local available = require("nvim-treesitter").get_available()
        return vim.tbl_contains(available, lang)
      end

      local function start_treesitter(buf, lang)
        if not vim.treesitter.language.add(lang) then
          vim.notify("Cannot load treesitter parser for language " .. lang, vim.log.levels.WARN)
          return
        end
        vim.treesitter.start(buf)
        vim.bo[buf].syntax = "ON"
        -- if vim.treesitter.query.get(lang, "indents") then
        --   vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        -- end
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then
            return
          end
          local buf = ev.buf
          if is_parser_installed(lang) then
            start_treesitter(buf, lang)
          elseif is_parser_available(lang) then
            require("nvim-treesitter").install({ lang }):await(function()
              start_treesitter(buf, lang)
            end)
          end
        end,
      })

      -- vim.api.nvim_create_autocmd("FileType", {
      --   callback = function(args)
      --     local ft = vim.bo[args.buf].filetype
      --     local lang = vim.treesitter.language.get_lang(ft)

      --     if not vim.treesitter.language.add(lang) then
      --       local available = vim.g.ts_available or ts.get_available()
      --       if not vim.g.ts_available then
      --         vim.g.ts_available = available
      --       end
      --       if vim.tbl_contains(available, lang) then
      --         ts.install(lang)
      --       end
      --     end

      --     if vim.treesitter.language.add(lang) then
      --       vim.treesitter.start(args.buf, lang)
      --       -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      --       vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      --       vim.wo[0][0].foldmethod = "expr"
      --     end
      --   end,
      -- })

      -- indents (experimental)
      -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
    },
  },
}
