{ config, lib, hostSpec, ... }:
let
  home = hostSpec.home;
in
{
  imports = lib.custom.scanPaths ./.;

  # I think this is the cleanest way to do this given that I need to support both
  # standalone hm and hm baked into nixos or nix-darwin
  config.lib.file.mkDotfilesSymlinks = paths:
    builtins.listToAttrs (map
      (path: {
        name = path;
        value = { source = config.lib.file.mkOutOfStoreSymlink "${home}/dotfiles/${path}"; };
      })
      paths
    );
}
