{ isDarwin, config, pkgs, lib, ... }:
let
  cfg = config.my.docker;
in
{
  options.my.docker = {
    enable = lib.mkEnableOption "host docker module";
  };

  # need to exclude darwin here because at least one of these keys doesn't even exist in nix-darwin
  config = lib.optionalAttrs (!isDarwin) (lib.mkIf cfg.enable {
    users.users.${config.hostSpec.username}.extraGroups = [ "docker" ];
    virtualisation = {
      containers.enable = true;
      docker = {
        enable = true;
        storageDriver = "overlay2";
        daemon = {
          settings = {
            default-address-pools = [
              {
                base = "192.172.0.0/16";
                size = 24;
              }
            ];
            log-opts = {
              # max-size = "100m";
            };
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      dive
      docker-compose
    ];
  });
}
