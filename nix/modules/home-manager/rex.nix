{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.rex;
in
{
  options.my.rex = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "home rex module.";
      };
    };
  };

  imports = [ inputs.rex.homeManagerModules.default ];

  config = lib.mkIf cfg.enable {
    programs.rex = {
      enable = true;
      sshGuard = false;
    };

    # Enable systemd service. Linux only.
    services.rex = {
      enable = pkgs.stdenv.hostPlatform.isLinux;
      extraListen = [ "tailnet://:7297" ];
    };
  };
}
