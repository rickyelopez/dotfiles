{ pkgs, ... }:
{
  imports = [
    {
      _module.args = {
        disk = "/dev/disk/by-id/nvme-eui.0025385281b29033";
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
      interface = "enP8p1s0";
    };
    defaultGateway6 = {
      address = "fd00:750::1";
      interface = "enP8p1s0";
    };

    interfaces = {
      enP8p1s0 = {
        ipv4 = {
          addresses = [
            {
              address = "10.19.21.60";
              prefixLength = 24;
            }
          ];
        };
        ipv6 = {
          addresses = [
            {
              address = "fd00:750::60";
              prefixLength = 64;
            }
            {
              address = "fe80::60";
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

    nameservers = [ "10.19.21.6" ];
    search = [ "forestroot.elexpedition.com" ];
  };

  services.openssh.settings.AllowUsers = [ "root" ];
}
