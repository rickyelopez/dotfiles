{
  inputs,
  config,
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
      networking.id = 18;
    };
  };

  # Google Coral PCIe
  hardware.coral.pcie.enable = true;
  users.users.${config.hostSpec.username}.extraGroups = [ "coral" ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
