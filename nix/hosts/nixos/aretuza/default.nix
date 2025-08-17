{ inputs, host, ... }: {
  imports = [
    inputs.lix-module.nixosModules.default

    ./configuration.nix
    ./hardware-configuration.nix

    ../../common/optional/gaming.nix
  ];

  hostSpec = {
    username = "ricclopez";
    hostname = host;
    gpu = 2;
  };

  my = {
    bluetooth.enable = true;
    virtualisation.docker.enable = true;
    greetd.enable = true;
    hyprland.enable = true;
    monitors = [
      {
        name = "DP-3";
        primary = true;
        width = 2560;
        height = 1440;
        refreshRate = 240;
        workspace = "1";
        vrr = 2;
      }
      {
        name = "DP-4";
        width = 2560;
        height = 1440;
        x = 2560;
        workspace = "6";
      }
    ];
    nvidia.enable = true;
    opengl.enable = true;
    qt.enable = true;
    secureboot.enable = true;
    sops.enable = true;
    ssh.enable = true;
    thunar.enable = true;
    wayland.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
