local function get_mode()
  return vim.g.rust_analyzer_start_mode or "mux"
end

local mode_configs = {
  mux = {
    cmd = vim.lsp.rpc.connect("127.0.0.1", 27631),
    filetypes = nil,
  },
  vanilla = {
    cmd = { "rust-analyzer" },
    filetypes = nil,
  },
  disabled = {
    cmd = nil,
    filetypes = {},
  },
}

local function set_mode(mode)
  local mode_config = mode_configs[mode]
  if mode_config == nil then
    vim.notify("Invalid Rust LSP mode: " .. mode, vim.log.levels.ERROR)
    return
  end

  vim.g.rust_analyzer_start_mode = mode
  vim.lsp.config("rust_analyzer", mode_config)
  vim.notify("Rust LSP mode: " .. mode .. "; restart rust_analyzer to apply", vim.log.levels.INFO)
end

if not vim.g.rust_lsp_mode_command_created then
  vim.api.nvim_create_user_command("RustLspMode", function(opts)
    if opts.args == "" then
      vim.notify("Rust LSP mode: " .. get_mode(), vim.log.levels.INFO)
      return
    end

    set_mode(opts.args)
  end, {
    nargs = "?",
    complete = function()
      return { "mux", "vanilla", "disabled" }
    end,
    desc = "Show or switch Rust LSP mode",
  })
  vim.g.rust_lsp_mode_command_created = true
end

local mode_config = mode_configs[get_mode()]

return vim.tbl_deep_extend("force", mode_config, {
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
})
