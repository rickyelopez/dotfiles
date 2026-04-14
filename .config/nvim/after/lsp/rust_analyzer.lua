local function mux_is_running()
  local socket_check = vim.system({ "bash", "-c", "ss -tuplen 2>/dev/null | grep 27631" }):wait()
  return socket_check.code == 0
end

local function get_mode()
  if vim.g.rust_analyzer_start_mode ~= nil then
    return vim.g.rust_analyzer_start_mode
  end

  if mux_is_running() then
    vim.g.rust_analyzer_start_mode = "mux"
    return vim.g.rust_analyzer_start_mode
  end

  local choice = vim.fn.confirm(
    "Couldn't find an lspmux socket at localhost:27631. Start vanilla rust-analyzer?",
    "&Yes\n&No",
    2
  )

  if choice == 1 then
    vim.g.rust_analyzer_start_mode = "vanilla"
  else
    vim.g.rust_analyzer_start_mode = "disabled"
  end

  return vim.g.rust_analyzer_start_mode
end

local mode = get_mode()
local cmd = nil
local filetypes = nil

if mode == "mux" then
  cmd = vim.lsp.rpc.connect("127.0.0.1", 27631)
elseif mode == "vanilla" then
  cmd = { "rust-analyzer" }
elseif mode == "disabled" then
  filetypes = {}
end

if not vim.g.rust_lsp_reset_command_created then
  vim.api.nvim_create_user_command("RustLspReset", function()
    vim.g.rust_analyzer_start_mode = nil
    vim.lsp.enable("rust_analyzer", false)
    vim.lsp.enable("rust_analyzer", true)
    vim.notify("Rust LSP startup choice reset for this session", vim.log.levels.INFO)
  end, { desc = "Reset cached Rust LSP startup choice" })
  vim.g.rust_lsp_reset_command_created = true
end

return {
  cmd = cmd,
  filetypes = filetypes,
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
