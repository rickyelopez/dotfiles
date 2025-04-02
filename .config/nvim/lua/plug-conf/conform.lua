local map = require("utils").map

return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters = {
        black = {
          prepend_args = function()
            return vim.env.BLACK_CFG and { "--config", vim.env.BLACK_CFG } or {}
          end,
        },
        ["nixpkgs-fmt"] = {
          command = "nixpkgs-fmt",
        },
        ["sql-formatter"] = {
          command = "sql-formatter",
        },
        -- rustfmt = {
        --   options = {
        --     default_edition = "2021",
        --   },
        -- },
      },
      default_format_opts = {
        lsp_format = "fallback",
        async = true,
      },
      notify_no_formatters = true,
      notify_on_error = true,
      log_level = vim.log.levels.INFO,
      formatters_by_ft = {
        bzl = { "buildifier" },
        cpp = { "clang-format" }, -- note that c and cpp are different here, c uses `uncrustify`, configured in lspconfig.lua
        lua = { "stylua" },
        python = { "black" },
        typescriptreact = { "biome" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        sql = { "sql-formatter" },
        xml = { "xmlformat" },
        yaml = { "yamlfmt" },
        nix = { "nixpkgs-fmt" },
      },
    })

    local fmt = require("conform").format
    map("<leader>f", fmt, { "n", "v" }, {
      desc = "conform: format with conform",
      noremap = true,
      silent = true,
      nowait = true,
    })
  end,
}
