{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.remote-open.client;
in
{
  options.my.remote-open.client = {
    enable = lib.mkEnableOption "home remote-open client module.";
    port = lib.mkOption {
      type = lib.types.int;
      default = 9999;
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      ROPEN_PORT = "${toString cfg.port}";
    };
    home.packages = with pkgs; [
      (writeShellScriptBin "xdg-open" ''
        #!/usr/bin/env bash
        if [ -n $SSH_TTY ]; then
          echo "$@" | nc -N localhost "$ROPEN_PORT"
        else
          /usr/bin/xdg-open "$@"
        fi
      '')
    ];
  };
}
