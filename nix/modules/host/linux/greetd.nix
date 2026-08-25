{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.greetd;
  regreetPackage = config.services.displayManager.regreet.package;
  hyprlandPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  hyprlandConfig = pkgs.writeText "greetd-hyprland-config" /* lua */ ''
    hl.on("hyprland.start", function()
      -- hl.exec_cmd("systemctl --user import-environment")
      hl.exec_cmd("${regreetPackage}/bin/regreet -L trace; hyprctl dispatch 'hl.dsp.exit()'")
    end)

    hl.config({
      debug = { disable_logs = false},
      misc = {
          disable_hyprland_logo = true,
          disable_splash_rendering = true,
      },
    })
  '';
in
{
  options.my.greetd = {
    enable = lib.mkEnableOption "host greetd module.";
  };

  config = lib.mkIf cfg.enable {
    programs.seahorse.enable = true;

    services = {
      displayManager.regreet.enable = true;
      gnome.gnome-keyring.enable = true;
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "dbus-run-session ${hyprlandPackage}/bin/start-hyprland -- --config ${hyprlandConfig}";
          };
        };
      };
    };

    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      hyprlock.enableGnomeKeyring = true;
    };
  };
}
