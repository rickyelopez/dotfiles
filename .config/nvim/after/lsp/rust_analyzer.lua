local function reload_workspace(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })
  for _, client in ipairs(clients) do
    vim.notify("Reloading Cargo Workspace")
    client:request("rust-analyzer/reloadWorkspace", nil, function(err)
      if err then
        error(tostring(err))
      end
      vim.notify("Cargo workspace reloaded")
    end)
  end
end

return {
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(0, "LspCargoReload", function()
      reload_workspace(0)
    end, { desc = "Reload current cargo workspace" })

    vim.g.my_on_attach(client, bufnr)
  end,
  cmd = { vim.fn.executable("ra-multiplex") and "ra-multiplex" or "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      files = {
        watcher = "server",
      },
      check = {
        workspace = false,
      },
      inlayHints = {
        bindingModeHints = {
          enable = false,
        },
        chainingHints = {
          enable = true,
        },
        closingBraceHints = {
          enable = true,
          minLines = 25,
        },
        closureReturnTypeHints = {
          enable = "never",
        },
        lifetimeElisionHints = {
          enable = "never",
          useParameterNames = false,
        },
        maxLength = 25,
        parameterHints = {
          enable = true,
        },
        reborrowHints = {
          enable = "never",
        },
        renderColons = true,
        typeHints = {
          enable = true,
          hideClosureInitialization = false,
          hideNamedConstructor = false,
        },
      },
    },
  },
}
