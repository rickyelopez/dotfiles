{ pkgs, config, ... }: {
  imports = [
    {
      _module.args = {
        disk = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
        withSwap = true;
        swapSizeGigabytes = 4;
      };
    }
    ../../../disks/nixos-ext4.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # nfs
  boot.supportedFilesystems = [ "nfs" ];
  environment.systemPackages = with pkgs; [ nfs-utils ];
  services.rpcbind.enable = true;

  hardware.coral.pcie.enable = true;
  users.users.${config.hostSpec.username}.extraGroups = [ "coral" ];

  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 8555 8971 ];
  networking.firewall.allowedUDPPorts = [ ];

  networking.hosts = {
    "10.19.21.40" = [ "panama" "panama.forestroot.elexpedition.com" ];
  };

  services.openssh.settings.AllowUsers = [ "root" ];
}

