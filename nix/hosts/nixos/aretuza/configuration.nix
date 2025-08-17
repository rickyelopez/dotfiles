{ config, lib, ... }: {
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
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;

      windows = {
        "windows" =
          let
            # To determine the name of the windows boot drive, boot into edk2 first, then run
            # `map -c` to get drive aliases, and try out running `FS1:`, then `ls EFI` to check
            # which alias corresponds to which EFI partition.
            boot-drive = "FS4";
          in
          {
            title = "Windows";
            efiDeviceHandle = boot-drive;
            sortKey = "y_windows";
          };
      };

      edk2-uefi-shell.enable = true;
      edk2-uefi-shell.sortKey = "z_edk2";
    };
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
          (lib.custom.relativeToRoot "keys/id_new.pub")
        ];
        hostKeys = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };
    };
  };

  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
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

  powerManagement.cpuFreqGovernor = "performance";

  services = {
    upower.enable = true;
  };

  fileSystems = {
    "/home".neededForBoot = true;

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

    "/run/media/ricclopez/panama/Multimedia" = {
      device = "panama:/mnt/relief/Multimedia";
      fsType = "nfs";
      options = [ "noatime" "norelatime" "exec" "rw" "nolock" ];
    };
  };
}
