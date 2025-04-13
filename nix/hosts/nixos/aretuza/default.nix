{ inputs, host, ... }: {
  imports = [
    inputs.lix-module.nixosModules.default

    ./configuration.nix
    ./hardware-configuration.nix

    ../../common/core
    ../../common/optional/bluetooth.nix
    ../../common/optional/gaming.nix
    ../../common/optional/greetd.nix
    ../../common/optional/hyprland.nix
    ../../common/optional/nvidia.nix
    ../../common/optional/opengl.nix
    ../../common/optional/qt.nix
    # ../../common/optional/sddm.nix
    ../../common/optional/sops.nix
    ../../common/optional/ssh.nix
    ../../common/optional/thunar.nix
    ../../common/optional/wayland.nix

    ../../../modules/monitors.nix
  ];

  hostSpec = {
    username = "ricclopez";
    hostname = host;
    gpu = 2;
  };

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

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
