{ inputs, host, ... }: {
  imports = [
    inputs.lix-module.nixosModules.default

    ./configuration.nix
    ./hardware-configuration.nix

    ../../common/core
    ../../common/optional/bluetooth.nix
    ../../common/optional/gaming.nix
    ../../common/optional/hyprland.nix
    ../../common/optional/nvidia.nix
    ../../common/optional/opengl.nix
    ../../common/optional/qt.nix
    ../../common/optional/sddm.nix
    ../../common/optional/sops.nix
    ../../common/optional/ssh.nix
    ../../common/optional/thunar.nix
    ../../common/optional/wayland.nix

    ../../../modules/monitors.nix
  ];

  hostSpec = {
    username = "ricclopez";
    hostname = host;
    isLaptop = true;
  };

  monitors = [
    {
      name = "eDP-1";
      primary = true;
      width = 1920;
      height = 1080;
    }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
