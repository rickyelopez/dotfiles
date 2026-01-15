local cmd

local socket_check = vim.system({ "bash", "-c", "ss -tuplen 2>/dev/null | grep 27631" }):wait()

if socket_check.code == 0 then
  cmd = vim.lsp.rpc.connect("127.0.0.1", 27631)
else
  local choice = vim.fn.confirm(
    "Couldn't find an lspmux socket at localhots:27631. Do you want to start vanilla rust-analyzer??",
    "&Yes\n&No",
    2
  )
  if choice == 1 then
    cmd = { "rust-analyzer" }
  else
    cmd = {}
  end
end

return {
  cmd = cmd,
  settings = {
    ["rust-analyzer"] = {
      lspMux = {
        version = "1",
        method = "connect",
        server = "rust-analyzer",
      },
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
