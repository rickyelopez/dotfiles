{
  inputs,
  config,
  lib,
  pkgs,
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

  boot.kernelParams = [
    #   "i915.fbdev=0"
    "console=tty0"
    "console=ttyS0,115200"
    "loglevel=8"
    "i915.enable_guc=3"
    "xe.force_probe=a7a8"
    "i915.force_probe=!a7a8"
    "xe.probe_display=false"
  ];

  systemd.services."serial-getty@ttyS0".enable = true;

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

  boot.initrd.kernelModules = [ "xe" ];

  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # VA-API (iHD) userspace
      vpl-gpu-rt # oneVPL (QSV) runtime
      intel-compute-runtime # OpenCL (NEO) + Level Zero for Arc/Xe
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
  };

  # May help if FFmpeg/VAAPI/QSV init fails (esp. on Arc with i915):
  hardware.enableRedistributableFirmware = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
