{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.lab;
  labDomain = "forestroot.elexpedition.com";
in
{
  options.my.lab = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "host lab module.";

        proxmox-guest = lib.mkEnableOption "proxmox guest";

        networking = lib.mkOption {
          type = lib.types.submodule {
            options = {
              id = lib.mkOption {
                description = "Last octet of IPv4 addresses (if enabled) as well as last word of IPv6 addresses (if enabled) for each interface";
                type = lib.types.int;
              };

              defaultInterface = lib.mkOption {
                description = "Interface to use for IPv4 and IPv6 default gateway";
                type = lib.types.str;
                default = if cfg.proxmox-guest then "ens18" else "";
              };

              interfaces = lib.mkOption {
                type = lib.types.attrsOf (
                  lib.types.submodule {
                    options = {
                      ipv4Prefix = lib.mkOption {
                        description = "First three octets of IPv4 address to be defined for this interface";
                        type = lib.types.str;
                      };

                      ipv6Prefix = lib.mkOption {
                        description = "Prefix to use for IPv6 address for this interface. 'id' will be used for the last 16 bits.";
                        type = lib.types.str;
                      };
                    };
                  }
                );

                default =
                  if cfg.proxmox-guest then
                    {
                      ens18 = {
                        ipv4Prefix = "10.19.21";
                        ipv6Prefix = "fd00:750";
                      };
                      ens19 = {
                        ipv4Prefix = "10.19.99";
                        ipv6Prefix = "fd00:750:99";
                      };
                      ens20 = {
                        ipv4Prefix = "10.19.50";
                        ipv6Prefix = "fd00:750:50";
                      };
                    }
                  else
                    { };
              };
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {

    hostSpec = {
      username = "nonroot";
      isServer = true;
      isHeadless = true;
    };

    my = {
      ssh.enable = true;
      virtualisation.docker.enable = true;
    };

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
      nameservers = [ "10.19.21.9" ];

      domain = labDomain;

      search = [ labDomain ];

      defaultGateway =
        lib.mkIf
          (
            cfg.networking ? defaultInterface
            && cfg.networking.interfaces.${cfg.networking.defaultInterface} ? ipv4Prefix
          )
          {
            address = cfg.networking.interfaces.${cfg.networking.defaultInterface}.ipv4Prefix + ".1";
            interface = cfg.networking.defaultInterface;
          };

      defaultGateway6 =
        lib.mkIf
          (
            cfg.networking ? defaultInterface
            && cfg.networking.interfaces.${cfg.networking.defaultInterface} ? ipv6Prefix
          )
          {
            address = cfg.networking.interfaces.${cfg.networking.defaultInterface}.ipv6Prefix + "::1";
            interface = cfg.networking.defaultInterface;
          };

      interfaces = builtins.mapAttrs (interface: config: {
        ipv4 = lib.mkIf (config ? ipv4Prefix) {
          addresses = [
            {
              address = config.ipv4Prefix + ".${toString cfg.networking.id}";
              prefixLength = 24;
            }
          ];
        };
        ipv6 = lib.mkIf (config ? ipv6Prefix) {
          addresses = [
            {
              address = config.ipv6Prefix + "::${toString cfg.networking.id}";
              prefixLength = 64;
            }
          ];
        };
      }) cfg.networking.interfaces;
    };
  };
}
