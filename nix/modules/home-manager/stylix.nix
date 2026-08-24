{
  config,
  options,
  lib,
  ...
}:
let
  cfg = config.my.stylix;
in
{
  options.my.stylix = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "home stylix module.";
      };
    };

  };

  config =
    if options ? stylix then
      (lib.mkIf cfg.enable {
        stylix.targets = {
          neovim.enable = false;
        };
      })
    else
      { };
}
