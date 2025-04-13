{ pkgs, config, ... }: {
  imports = [
    {
      _module.args = {
        disk = "/dev/disk/by-id/nvme-CT1000P2SSD8_2139E5D674DF";
        withSwap = true;
        swapSizeGigabytes = 64;
      };
    }
    ../../../disks/nixos-luks-btrfs.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # format of the following described here: https://www.kernel.org/doc/Documentation/filesystems/nfs/nfsroot.txt
  # tl;dr: client-ip:server-ip (skipped here):gateway:netmask:hostname:network device (skipped here):autoconf mode

  boot.kernelParams = [ "ip=10.19.21.20::10.19.21.1:255.255.255.0:${config.hostSpec.hostname}::none" ];
  # boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    availableKernelModules = [
      "r8169" # make network driver available
      "aesni_intel" # hopefully speed up decrypting
      "cryptd" # hopefully speed up decrypting
    ];
    systemd.users.root.shell = "/bin/cryptsetup-askpass";
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 22;
        authorizedKeyFiles = [
          ../../../keys/id_old.pub
          ../../../keys/id_new.pub
        ];
        hostKeys = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };
    };
  };

  programs = { zsh.enable = true; };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  networking.networkmanager.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking = {
    interfaces = {
      enp7s0.ipv4.addresses = [{
        address = "10.19.21.20";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "10.19.21.1";
      interface = "enp7s0";
    };
    nameservers = [ "10.19.21.6" ];
    search = [ "forestroot.elexpedition.com" ];
  };

  services = {
    upower.enable = true;
  };

  fileSystems = {
    "/run/media/ricclopez/FastFastData" = {
      device = "/dev/disk/by-label/FastFastData";
      fsType = "ntfs";
      options = [ "auto" "noatime" "norelatime" "exec" "rw" "uid=1000" "gid=100" ];
    };

    "/run/media/ricclopez/FastData2" = {
      device = "/dev/disk/by-label/FastData2";
      fsType = "ntfs";
      options = [ "auto" "noatime" "norelatime" "exec" "rw" "uid=1000" "gid=100" ];
    };

    "/run/media/ricclopez/Windows" = {
      device = "/dev/disk/by-id/nvme-SHGP31-1000GM_KNB7N77341030863K-part4";
      fsType = "ntfs";
      options = [ "auto" "noatime" "norelatime" "exec" "rw" "uid=1000" "gid=100" ];
    };
  };
}
