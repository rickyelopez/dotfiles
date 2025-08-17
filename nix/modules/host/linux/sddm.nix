{ config, lib, ... }:
let
  cfg = config.my.sddm;
in
{
  options.my.sddm = {
    enable = lib.mkEnableOption "host sddm module.";
    wayland = lib.mkEnableOption "wayland sddm integration.";
  };

  config = lib.mkIf cfg.enable {
    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = cfg.wayland;
      };
    };
  };
}
