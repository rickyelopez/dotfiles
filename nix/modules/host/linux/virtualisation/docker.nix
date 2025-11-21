{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.virtualisation.docker;
in
{
  options.my.virtualisation.docker = {
    enable = lib.mkEnableOption "host docker module";
  };

  config = lib.mkIf cfg.enable {
    users.users.${config.hostSpec.username}.extraGroups = [ "docker" ];
    virtualisation = {
      containers.enable = true;
      docker = {
        enable = true;
        storageDriver = "overlay2";
        logDriver = "journald";
        liveRestore = true;
        daemon = {
          settings = {
            default-address-pools = [
              {
                base = "192.172.0.0/16";
                size = 24;
              }
            ];
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      dive
      docker-compose
    ];
  };
}
