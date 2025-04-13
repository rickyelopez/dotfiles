{ pkgs, lib, monitors, ... }:
let
  monitor = lib.head (lib.filter (m: m.primary) monitors);

  steam-session =
    let
      gamescope = lib.concatStringsSep " " [
        (lib.getExe pkgs.gamescope)
        "--output-width ${toString monitor.width}"
        "--output-height ${toString monitor.height}"
        "--framerate-limit ${toString (monitor.refreshRate * 2)}"
        "--prefer-output ${monitor.name}"
        "--adaptive-sync"
        "--expose-wayland"
        "--steam"
        "--hdr-enabled"
      ];
      steam = lib.concatStringsSep " " [
        "steam"
      ];
    in
    pkgs.writeTextDir "share/applications/steam-session.desktop" ''
      [Desktop Entry]
      Name=Steam Session
      Exec=${gamescope} -- ${steam}
      Icon=steam
      Type=Application
    '';
in
{
  home.packages =
    [
      # disabled for now, gamescope does not appear to be working with nvidia
      # steam-session
    ];

}

