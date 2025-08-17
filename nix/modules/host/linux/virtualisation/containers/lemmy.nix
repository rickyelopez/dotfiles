{ config, lib, ... }:
let
  cfg = config.my.containers.lemmy;
in
{
  options.my.containers.lemmy = {
    enable = lib.mkEnableOption "lemmy container.";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      10633 # lemmy server
    ];
  };
}
