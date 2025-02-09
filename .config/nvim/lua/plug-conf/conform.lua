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
        -- rustfmt = {
        --   options = {
        --     default_edition = "2021",
        --   },
        -- },
      },
      formatters_by_ft = {
        bzl = { "buildifier" },
        cpp = { "clang-format" }, -- note that c and cpp are different here, c uses `uncrustify`, configured in lspconfig.lua
        lua = { "stylua" },
        python = { "black" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        xml = { "xmlformat" },
        yaml = { "yamlfmt" },
        nix = { "nixpkgs-fmt" },
      },
    })
  end,
}
