{ config, inputs, pkgs, lib, ... }:
let
  cfg = config.my.hyprland;
in
{
  options.my.hyprland = {
    enable = lib.mkEnableOption "host hyprland module.";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    environment.systemPackages = [
      inputs.hyprpolkitagent.packages.${pkgs.system}.default
    ];

    programs = {
      hyprland = {
        enable = true;
        withUWSM = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      };
      hyprlock = {
        enable = true;
        package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
      };
    };

    xdg.portal = {
      enable = true;
      wlr.enable = lib.mkForce true;
      config = {
        common = {
          default = [ "hyprland;gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
      };
      xdgOpenUsePortal = true;
    };
  };
}
