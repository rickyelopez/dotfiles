{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.remote-open;
  handler = pkgs.writeShellScriptBin "ropen" ''
    #!/usr/bin/env bash
    set -euo pipefail
    DATA="$(cat)"
    echo "remote-open got: $(printf '%s' "$DATA" | wc -c | tr -d ' ') bytes"
    open "$DATA"
  '';
in
{
  options.my.remote-open = {
    enable = lib.mkEnableOption "home remote-open module.";
    port = lib.mkOption {
      type = lib.types.int;
      default = 9999;
    };
  };

  config = lib.mkIf cfg.enable {
    launchd = {
      enable = true;

      agents.remote-open = {
        enable = true;
        config = {
          Label = "com.example.remote-open.user";
          ProgramArguments = [ "${handler}/bin/ropen" ];
          inetdCompatibility = {
            Wait = false;
          };
          Sockets = {
            Listeners = {
              SockServiceName = "${toString cfg.port}";
              SockType = "stream";
              SockFamily = "IPv4";
              SockNodeName = "127.0.0.1";
            };
          };
          # For agents, log to ~/Library/Logs is typical; stdout/err can still be set if desired.
        };
      };
    };
  };
}
