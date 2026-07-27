{ host, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
  ];

  hostSpec = {
    username = "nonroot";
    hostname = host;
    networking = {
      addresses = {
        ipv4 = "10.19.21.61";
      };
    };
    isServer = true;
    isHeadless = true;
  };

  disko.devices.disk = {
    disk0 = import ../../../disks/layouts/nixos-ext4.nix {
      device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4162e99a";
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
              address = "10.19.21.61";
              prefixLength = 24;
            }
          ];
        };
        ipv6 = {
          addresses = [
            {
              address = "fd00:750::61";
              prefixLength = 64;
            }
            {
              address = "fe80::61";
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
