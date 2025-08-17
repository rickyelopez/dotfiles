{ config, lib, ... }:
let
  cfg = config.my.ssh;
in
{
  options.my.ssh = {
    enable = lib.mkEnableOption "host ssh module.";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      authorizedKeysInHomedir = true;
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ config.hostSpec.username ];
        PermitRootLogin = "prohibit-password";
      };
    };

    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
