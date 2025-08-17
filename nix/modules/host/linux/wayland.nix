{ config, pkgs, lib, ... }:
let
  cfg = config.my.wayland;
in
{
  options.my.wayland = {
    enable = lib.mkEnableOption "host wayland module.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      grim
      slurp
      swappy
    ];

    my.sddm.wayland = true;
  };
}
