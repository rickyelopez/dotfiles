{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (!config.hostSpec.isHeadless) {
    environment.systemPackages = with pkgs; [ bitwarden-desktop ];

    programs = {
      nm-applet.enable = config.hostSpec.isLaptop;
    };
  };
}
