return {
  cmd = { "nixd", "--inlay-hints", "--semantic-tokens" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", "git" },
  settings = {
    nixd = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
}
