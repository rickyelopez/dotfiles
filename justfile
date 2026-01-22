set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

dotfiles := justfile_dir()

[macos]
build:
  darwin-rebuild build --flake {{dotfiles}}

[macos]
switch:
  sudo darwin-rebuild switch --flake {{dotfiles}}


bootstrap:
  nix run --experimental-features 'nix-command flakes' {{dotfiles}} -- switch --experimental-features 'nix-command flakes' --flake {{dotfiles}}

is_nixos := path_exists("/etc/nixos")

[linux]
build:
  #!/usr/bin/env bash
  if [[ "{{is_nixos}}" == "true" ]]; then
    nixos-rebuild build --flake {{dotfiles}} --no-build-output
  else
    nix run {{dotfiles}} -- --no-out-link build --flake {{dotfiles}}
  fi

[linux]
switch:
  #!/usr/bin/env bash
  if [[ "{{is_nixos}}" == "true" ]]; then
    sudo nixos-rebuild switch --flake {{dotfiles}}
  else
    nix run {{dotfiles}} -- switch --flake {{dotfiles}}
  fi
