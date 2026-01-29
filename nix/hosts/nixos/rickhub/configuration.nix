{ pkgs, ... }:
{
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

  networking = {
    defaultGateway = {
      address = "10.19.21.1";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "fd00:750::1";
      interface = "ens18";
    };

    interfaces = {
      ens18 = {
        ipv4 = {
          addresses = [
            {
              address = "10.19.21.26";
              prefixLength = 24;
            }
          ];
        };
        ipv6 = {
          addresses = [
            {
              address = "fd00:750::26";
              prefixLength = 64;
            }
            {
              address = "fe80::26";
              prefixLength = 64;
            }
          ];
        };
      };

      ens19 = {
        ipv4 = {
          addresses = [
            {
              address = "10.19.99.26";
              prefixLength = 24;
            }
          ];
        };
      };

      ens20 = {
        ipv4 = {
          addresses = [
            {
              address = "10.19.50.26";
              prefixLength = 24;
            }
          ];
        };
      };
    };

    hosts = {
      "10.19.21.40" = [
        "panama"
        "panama.forestroot.elexpedition.com"
      ];
    };

    nameservers = [ "10.19.21.6" ];
    search = [ "forestroot.elexpedition.com" ];
  };

  services.qemuGuest.enable = true;
  services.openssh.settings.AllowUsers = [ "root" ];
}
