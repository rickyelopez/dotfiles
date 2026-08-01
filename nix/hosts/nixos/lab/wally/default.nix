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
      device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4162e99a";
      withSwap = true;
      swapSizeGigabytes = 4;
    };
  };

  my = {
    lab = {
      enable = true;
      networking = {
        id = 61;
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
