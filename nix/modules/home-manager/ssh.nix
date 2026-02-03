{
  lib,
  config,
  hostSpec,
  ...
}:
let
  cfg = config.my.ssh;
  identityFiles = [
    "id_new"
    "id_old"
  ];
  standardHosts = [
    {
      host = "barry";
      user = "nonroot";
    }
    {
      host = "cintra";
      user = "nonroot";
    }
    {
      host = "cutiepie";
      user = "nonroot";
    }
    {
      host = "dns-01";
      user = "nonroot";
    }
    {
      host = "ferrix";
      user = "nonroot";
    }
    {
      host = "fob";
      user = "root";
    }
    {
      host = "fondor";
      user = "root";
    }
    {
      host = "hermes";
      user = "nonroot";
    }
    {
      host = "panama";
      user = "root";
    }
    {
      host = "rickhub";
      user = "nonroot";
    }
    {
      host = "sathub";
      user = "nonroot";
    }
  ];
  standardHostConfigs = lib.attrsets.mergeAttrsList (
    lib.lists.map (cfg: {
      "${cfg.host}" = {
        # match = "host ${host},${host}.${config.hostSpec.domain}";
        user = cfg.user;
        forwardAgent = true;
        identityFile = lib.lists.forEach identityFiles (file: "${hostSpec.home}/.ssh/${file}");
      };
    }) standardHosts
  );
in
{
  options.my.ssh = {
    enable = lib.mkEnableOption "home ssh module.";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          controlMaster = "auto";
          controlPath = "${hostSpec.home}/.ssh/sockets/S.%r@%h:%p";
          controlPersist = "20m";
          # Avoids infinite hang if control socket connection interrupted. ex: vpn goes down/up
          serverAliveCountMax = 3;
          serverAliveInterval = 5; # 3 * 5s

          hashKnownHosts = true;
          addKeysToAgent = "yes";
        };
        "git" = {
          host = "github.com";
          user = "git";
          forwardAgent = false;
          identitiesOnly = true;
          identityFile = lib.lists.forEach identityFiles (file: "${hostSpec.home}/.ssh/${file}");
        };
      }
      // standardHostConfigs
      // lib.optionalAttrs (!hostSpec.isWork) {
        "git-dg" = {
          host = "dg.github.com";
          hostname = "github.com";
          user = "git";
          forwardAgent = false;
          identitiesOnly = true;
          identityFile = "${hostSpec.home}/.ssh/id_dg";
        };
      };
    };

    home.file = {
      ".ssh/sockets/.keep".text = "# Managed by Home Manager";
    };
  };
}
