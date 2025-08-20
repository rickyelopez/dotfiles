return {
  { "p00f/clangd_extensions.nvim", lazy = true },
  { "williamboman/mason.nvim", config = true, opts = { log_level = vim.log.levels.DEBUG } },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
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
        "ruff",
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
        "bazelrc-lsp",
        "black",
        "buildifier",
        "codespell",
        "nixpkgs-fmt",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "stylua",
        "taplo",
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
