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
        -- rustfmt = {
        --   options = {
        --     default_edition = "2021",
        --   },
        -- },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        yaml = { "yamlfmt" },
        rust = { "rustfmt" },
        xml = { "xmlformat" },
      },
    })
  end,
}
