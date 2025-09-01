{ inputs, host, ... }: {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix

    ../../common/optional/gaming.nix
  ];

  hostSpec = {
    username = "ricclopez";
    hostname = host;
    isLaptop = true;
  };

  my = {
    bluetooth.enable = true;
    hyprland.enable = true;
    monitors = [
      {
        name = "eDP-1";
        primary = true;
        width = 1920;
        height = 1080;
        workspace = "1";
      }
    ];
    nvidia.enable = true;
    opengl.enable = true;
    qt.enable = true;
    sddm.enable = true;
    sops.enable = true;
    ssh.enable = true;
    thunar.enable = true;
    wayland.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
