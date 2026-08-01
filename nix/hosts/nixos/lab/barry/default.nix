{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
  ];

  disko.devices.disk = {
    disk0 = import (lib.custom.relativeToRoot "disks/layouts/nixos-ext4.nix") {
      device = "/dev/disk/by-id/nvme-eui.0025385281b29033";
      withSwap = true;
      swapSizeGigabytes = 4;
    };
  };

  my = {
    lab = {
      enable = true;
      networking = {
        id = 60;
        defaultInterface = "enP8p1s0";
        interfaces = {
          enP8p1s0 = {
            ipv4Prefix = "10.19.21";
            ipv6Prefix = "fd00:750";
          };
        };
      };
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";
}
