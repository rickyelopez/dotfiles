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
          members = [ "nonroot" ];
        };
      };

      users = {
        media = {
          uid = 1010;
          group = "media";
          isSystemUser = true;
        };
      };
    };
  };
}
