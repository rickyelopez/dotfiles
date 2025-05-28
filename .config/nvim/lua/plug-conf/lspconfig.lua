return {
  { "p00f/clangd_extensions.nvim", lazy = true },
  { "williamboman/mason.nvim", config = true, opts = { log_level = vim.log.levels.DEBUG } },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = true,
    opts = {
      ensure_installed = {
        "basedpyright",
        "bashls",
        "clangd",
        "jsonls",
        "lua_ls",
        "nil_ls",
        "rust_analyzer",
        "taplo",
        "vimls",
        "yamlls",
        "zls",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = true,
    opts = {
      ensure_installed = {
        "black",
        "nixpkgs-fmt",
        "shellcheck",
        "shfmt",
        "stylua",
        "yamlfmt",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000, -- 3 second delay at startup
      debounce_hours = 5, -- at least 5 hours between attempts to install/update
    },
  },
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = true,
  },
}
