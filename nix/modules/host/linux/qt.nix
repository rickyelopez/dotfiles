{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.qt;
in
{
  options.my.qt = {
    enable = lib.mkEnableOption "host qt module.";
  };

  config = lib.mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };

    environment.systemPackages = with pkgs; [
      libsForQt5.qt5ct
    ];
  };
}
