return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- icons
    "onsails/lspkind.nvim",
    -- snippets
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    -- completion
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/cmp-path",
  },
  config = function()
    vim.opt.completeopt = "menu,menuone,noinsert,noselect,preview"

    local cmp = require("cmp")

    cmp.setup({
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }), -- Set `select` to `false` to only confirm explicitly selected items.
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<Esc>"] = function()
          cmp.mapping.abort()
          vim.cmd("stopinsert")
        end,
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      }),
      sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
      }),
      completion = {
        keyword_length = 1,
        completeopt = "menu,menuone,noinsert,noselect,preview",
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.offset,
          require("clangd_extensions.cmp_scores"),
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          -- cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      ---@diagnostic disable-next-line: missing-fields
      formatting = {
        format = require("lspkind").cmp_format({
          mode = "symbol_text",
          show_labelDetails = true,
          menu = {
            nvim_lsp = "[LSP]",
            luasnip = "[Snip]",
            path = "[Path]",
            buffer = "[Buffer]",
          },
        }),
      },
    })
  end,
}
