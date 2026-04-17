{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.hyprland;
  hyprlandPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
in
{
  options.my.hyprland = {
    enable = lib.mkEnableOption "host hyprland module.";
  };

  config = lib.mkIf cfg.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    environment.systemPackages = [
      inputs.hyprpolkitagent.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    programs = {
      hyprland = {
        enable = true;
        withUWSM = true;
        package = hyprlandPackage;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
      hyprlock = {
        enable = true;
        package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;
      };
      uwsm.waylandCompositors.hyprland.binPath = lib.mkForce "/run/current-system/sw/bin/start-hyprland";
      uwsm.waylandCompositors.hyprland.prettyName = "Hyprland";
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
