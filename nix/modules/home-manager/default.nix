{ config, lib, hostSpec, ... }:
let
  home = hostSpec.home;
  homeFiles = lib.custom.scanPaths ../home-manager; # path "." doesn't work for some reason
in
{
  imports = [ ] ++ homeFiles;

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
