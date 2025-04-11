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
  ];

  hostSpec = {
    username = "ricclopez";
    hostname = host;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
