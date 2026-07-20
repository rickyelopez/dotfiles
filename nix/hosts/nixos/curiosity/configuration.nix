{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices.disk = {
    disk0 = import ../../../disks/layouts/nixos-ext4.nix {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
      withSwap = true;
      swapSizeGigabytes = 8;
    };
    disk1 = {
    # disk-disk1-data
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
              address = "10.19.21.41";
              prefixLength = 24;
            }
          ];
        };
        ipv6 = {
          addresses = [
            {
              address = "fd00:750::41";
              prefixLength = 64;
            }
            {
              address = "fe80::41";
              prefixLength = 64;
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

    nameservers = [ "10.19.21.9" ];
    search = [ "forestroot.elexpedition.com" ];
  };

  services.qemuGuest.enable = true;
  services.openssh.settings.AllowUsers = [ "root" ];

  my = {
    containers = { };
    lab.enable = true;
    nvidia = {
      enable = true;
      runtime.enable = true;
      open = false;
    };
  };
}
