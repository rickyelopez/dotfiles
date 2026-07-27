{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.lab;
  labDomain = "forestroot.elexpedition.com";
  lastOctet = builtins.elemAt (lib.splitString "." config.hostSpec.networking.addresses.ipv4) 3;
in
{
  options.my.lab = {
    enable = lib.mkEnableOption "host lab module.";
    proxmox-guest = lib.mkEnableOption "proxmox guest";
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups = {
        media = {
          gid = 1010;
          members = [
            "nonroot"
            "nextcloud"
            "priv"
          ];
        };
        nextcloud = {
          gid = 1020;
          members = [ "nonroot" ];
        };
        priv = {
          gid = 1030;
          members = [ "nonroot" ];
        };
        traefik = {
          gid = 2000;
          members = [ "nonroot" ];
        };
      };

      users = {
        media = {
          uid = 1010;
          group = "media";
          isSystemUser = true;
        };
        nextcloud = {
          uid = 1020;
          group = "nextcloud";
          isSystemUser = true;
        };
        priv = {
          uid = 1030;
          group = "priv";
          isSystemUser = true;
        };
        traefik = {
          uid = 2000;
          group = "traefik";
          isSystemUser = true;
        };
      };
    };

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      initrd.availableKernelModules =
        if cfg.proxmox-guest then
          [
            "9p"
            "9pnet_virtio"
            "ahci"
            "ehci_pci"
            "sd_mod"
            "sr_mod"
            "uhci_hcd"
            "virtio_blk"
            "virtio_mmio"
            "virtio_net"
            "virtio_pci"
            "virtio_scsi"
            "virtiofs"
          ]
        else
          [ ];

      initrd.kernelModules =
        if cfg.proxmox-guest then
          [
            "virtio_balloon"
            "virtio_console"
            "virtio_rng"
            "virtio_gpu"
          ]
        else
          [ ];
    };

    services = {
      openssh.settings.AllowUsers = [ "root" ];
      qemuGuest.enable = cfg.proxmox-guest;
    };

    # enable support for nfs mounts
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

      nameservers = [ "10.19.21.9" ];

      domain = labDomain;

      search = [ labDomain ];

      interfaces = lib.mkIf cfg.proxmox-guest {
        ens18 = {
          ipv4 = {
            addresses = [
              {
                address = config.hostSpec.networking.addresses.ipv4;
                prefixLength = 24;
              }
            ];
          };
          ipv6 = {
            addresses = [
              {
                address = "fd00:750::${lastOctet}";
                prefixLength = 64;
              }
              {
                address = "fe80::${lastOctet}";
                prefixLength = 64;
              }
            ];
          };
        };
      };
    };
  };
}
