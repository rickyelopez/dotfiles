[macos]
build:
  darwin-rebuild build --flake ~/dotfiles

[linux]
build:
  nix run ~/dotfiles -- build --flake ~/dotfiles

[macos]
switch:
  darwin-rebuild switch --flake ~/dotfiles

[linux]
switch:
  nix run ~/dotfiles -- switch --flake ~/dotfiles

bootstrap:
  nix run --experimental-features 'nix-command flakes' ~/dotfiles -- switch --experimental-features 'nix-command flakes' --flake ~/dotfiles

update:
  cd ~/dotfiles && nix flake update
