{
  host,
  inputs,
  config,
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
        ipv4 = "10.19.21.18";
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
    containers = {
      frigate.enable = true;
      lemmy.enable = true;
      teamspeak.enable = true;
    };
    lab = {
      enable = true;
      proxmox-guest = true;
    };
    ssh.enable = true;
    virtualisation.docker.enable = true;
  };

  # Google Coral PCIe
  hardware.coral.pcie.enable = true;
  users.users.${config.hostSpec.username}.extraGroups = [ "coral" ];

  networking = {
    interfaces = {
      ens19 = {
        ipv4 = {
          addresses = [
            {
              address = "10.19.99.18";
              prefixLength = 24;
            }
          ];
        };
      };

      ens20 = {
        ipv4 = {
          addresses = [
            {
              address = "10.19.50.18";
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
