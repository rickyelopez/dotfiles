{ lib, config, ... }:
let
  cfg = config.my.docker;
in
{
  options.my.docker = {
    enable = lib.mkEnableOption "home docker module";
  };

  config.home = lib.mkIf cfg.enable {
    shellAliases = {
      dc = "docker compose";
      logs = "docker compose logs -f --tail";
    };
  };
}

