{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices.disk = {
    disk0 = import (lib.custom.relativeToRoot "disks/layouts/nixos-ext4.nix") {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
      withSwap = true;
      swapSizeGigabytes = 8;
    };
    disk1 = {
      type = "disk";
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1";
      content = {
        type = "gpt";
        partitions = {
          data = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/data";
              mountOptions = [
                "noatime"
              ];
            };
          };
        };
      };
    };
  };

  my = {
    lab = {
      enable = true;
      proxmox-guest = true;
      networking.id = 41;
    };
    nvidia = {
      enable = true;
      cuda = true;
      open = false;
      runtime.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
