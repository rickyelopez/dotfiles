{
  inputs,
  host,
  lib,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
  ];

  hostSpec = {
    username = "nonroot";
    hostname = host;
    isServer = true;
    isHeadless = true;
    networking = {
      addresses = {
        ipv4 = "10.19.21.60";
      };
    };
  };

  disko.devices.disk = {
    disk0 = import (lib.custom.relativeToRoot "disks/layouts/nixos-ext4.nix") {
      device = "/dev/disk/by-id/nvme-eui.0025385281b29033";
      withSwap = true;
      swapSizeGigabytes = 4;
    };
  };

  my = {
    lab.enable = true;
    ssh.enable = true;
    virtualisation.docker.enable = true;
  };

  networking = {
    interfaces = {
      enP8p1s0 = {
        ipv4 = {
          addresses = [
            {
              address = "10.19.21.60";
              prefixLength = 24;
            }
          ];
        };
        ipv6 = {
          addresses = [
            {
              address = "fd00:750::60";
              prefixLength = 64;
            }
            {
              address = "fe80::60";
              prefixLength = 64;
            }
          ];
        };
      };
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";
}
