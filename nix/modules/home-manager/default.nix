{
  config,
  lib,
  hostSpec,
  ...
}:
let
  home = hostSpec.home;
in
{
  imports = lib.custom.scanPaths ./.;

  # for anything I want to be able to just modify directly without having to rebuild
  config.lib.file.mkDotfilesSymlinks =
    paths:
    builtins.listToAttrs (
      map (path: {
        name = path;
        value = {
          source = config.lib.file.mkOutOfStoreSymlink "${home}/dotfiles/${path}";
        };
      }) paths
    );
}
