{ config, lib, ... }:
let
  cfg = config.my.qt;
in {
  options.my.qt = {
    enable = lib.mkEnableOption "home qt module.";
  };

  config = lib.mkIf cfg.enable {
    home = {
      file = config.lib.file.mkDotfilesSymlinks [
        ".config/Kvantum"
      ];
    };
  };
}
