return {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", "git" },
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      options = {
        nixos = {
          expr = vim.fn.expand('(builtins.getFlake ("git+file://$HOME/dotfiles")).nixosConfigurations.$HOST.options'),
        },
        ["home-manager"] = {
          expr = vim.fn.expand(
            '(builtins.getFlake ("git+file://$HOME/dotfiles")).nixosConfigurations.$HOST.options.home-manager.users.type.getSubOptions'
          ) .. " []",
        },
      },
    },
  },
}
