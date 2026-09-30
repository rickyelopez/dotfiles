{
  config,
  hostSpec,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.vicinae;
in
{
  options.my.vicinae = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "home vicinae module.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = if hostSpec.isDarwin then [ pkgs.vicinae ] else [ ];
    };

    programs.vicinae = {
      enable = (!hostSpec.isDarwin);
    };
  };
}
