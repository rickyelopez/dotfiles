build:
  darwin-rebuild build --flake ~/dotfiles
  # nix run ~/dotfiles -- build --flake ~/dotfiles

switch:
  darwin-rebuild switch --flake ~/dotfiles
  # nix run ~/dotfiles -- switch --flake ~/dotfiles

bootstrap:
  nix run --experimental-features 'nix-command flakes' ~/dotfiles -- switch --experimental-features 'nix-command flakes' --flake ~/dotfiles
