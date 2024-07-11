return {
  "saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  -- TODO: figure out how to get LSP running here. Need to get `on_attach` from lspconfig
  -- opts = {
  --   lsp = {
  --     enabled = true,
  --     on_attach = function(client, bufnr)
  --       -- the same on_attach function as for your other lsp's
  --     end,
  --     actions = true,
  --     completion = true,
  --     hover = true,
  --   },
  -- },
  config = true,
}
