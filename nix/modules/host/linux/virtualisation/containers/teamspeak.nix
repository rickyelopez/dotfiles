{ config, lib, ... }:
let
  cfg = config.my.containers.teamspeak;
in
{
  options.my.containers.teamspeak = {
    enable = lib.mkEnableOption "teamspeak container.";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [
      9987 # teamspeak server
    ];
  };
}
