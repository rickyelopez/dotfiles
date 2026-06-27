{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (!config.hostSpec.isHeadless) {
    environment.systemPackages = with pkgs; [ bitwarden-desktop ];

    # bitwarden-desktop still pins EOL Electron 39 (NixOS/nixpkgs#526914).
    # Accept the risk window until upstream bumps it; nixpkgs already
    # aliases `electron_39 = electron_39-bin` so no overlay is needed.
    # Remove this once bitwarden-desktop moves to a supported Electron.
    nixpkgs.config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];

    programs = {
      nm-applet.enable = config.hostSpec.isLaptop;
    };
  };
}
