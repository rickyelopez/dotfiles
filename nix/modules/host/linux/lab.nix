{ config, lib, ... }:
let
  cfg = config.my.lab;
in
{
  options.my.lab = {
    enable = lib.mkEnableOption "host lab module.";
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
  };
}
