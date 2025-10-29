{ lib, pkgs, ... }:
{
  environment.variables = {
    VDPAU_DRIVER = "nvidia";
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    graphics = {
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "i915.enable_guc=2" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/70e6f722-c844-42e4-8f93-96ba8e0c6f91";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/74A8-C0D9";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/34085f96-d70e-49da-bfc5-20868954ea6a"; } ];

  networking.useDHCP = lib.mkDefault true;
}
