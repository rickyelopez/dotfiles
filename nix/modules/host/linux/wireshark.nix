{ config, pkgs, lib, ... }:
let cfg = config.my.wireshark;
in {
  options.my.wireshark = {
    enable = lib.mkEnableOption "host wireshark module.";
  };

  config = lib.mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    users.users.${config.hostSpec.username}.extraGroups = [ "wireshark" ];
  };
}

