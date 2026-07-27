{ host, inputs, ... }:
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
        ipv4 = "10.19.21.36";
      };
    };
  };

  disko.devices.disk = {
    disk0 = import ../../../disks/layouts/nixos-ext4.nix {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
      withSwap = true;
      swapSizeGigabytes = 8;
    };
  };

  my = {
    lab = {
      enable = true;
      proxmox-guest = true;
    };
    nvidia = {
      enable = true;
      runtime.enable = true;
    };
    ssh.enable = true;
    virtualisation.docker.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
