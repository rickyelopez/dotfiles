{
  host,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  hostSpec = {
    username = "nonroot";
    hostname = host;
    isServer = true;
    isHeadless = true;
    networking = {
      addresses = {
        ipv4 = "10.19.21.24";
      };
    };
  };

  disko.devices.disk = {
    disk0 = import ../../../disks/layouts/nixos-ext4.nix {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
      withSwap = true;
      swapSizeGigabytes = 4;
    };
  };

  my = {
    lab = {
      enable = true;
      proxmox-guest = true;
    };
    ssh.enable = true;
    virtualisation.docker.enable = true;
  };

  environment.systemPackages = with pkgs; [
    iptables
    nftables
  ];

  networking = {
    firewall = {
      enable = true;
      logReversePathDrops = true;
    };

    interfaces = {
      ens19 = {
        ipv4 = {
          addresses = [
            {
              address = "10.19.99.24";
              prefixLength = 24;
            }
          ];
        };
      };

      ens20 = {
        ipv4 = {
          addresses = [
            {
              address = "10.19.50.24";
              prefixLength = 24;
            }
          ];
        };
      };
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
