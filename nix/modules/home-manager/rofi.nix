{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.rofi;
in
{
  options.my.rofi = {
    enable = lib.mkEnableOption "home rofi module.";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        rofi
      ];

      file = config.lib.file.mkDotfilesSymlinks [
        ".config/rofi"
      ];
    };
  };
}
