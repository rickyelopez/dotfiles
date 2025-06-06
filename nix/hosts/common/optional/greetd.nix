{ inputs, pkgs, config, ... }:
let
  hyprlandPackage = inputs.hyprland.packages.${pkgs.system}.hyprland;
  hyprlandConfig = pkgs.writeText "greetd-hyprland-config" ''
    exec-once = ${config.programs.regreet.package}/bin/regreet; hyprctl dispatch exit
    exec systemctl --user import-environment
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        disable_hyprland_qtutils_check = true
    }
  '';
in
{
  programs = {
    seahorse.enable = true;
    regreet = {
      enable = true;
      theme = {
        package = pkgs.tokyonight-gtk-theme;
        name = "Tokyonight-Dark";
      };
    };
  };

  services = {
    gnome.gnome-keyring.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${hyprlandPackage}/bin/Hyprland --config ${hyprlandConfig}";
        };
      };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.hyprlock.enableGnomeKeyring = true;
}
