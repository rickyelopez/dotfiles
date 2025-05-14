return {
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      hint = {
        enable = true, -- necessary
      },
      telemetry = {
        enable = false,
      },
      format = {
        enable = false,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
    },
  },
}
