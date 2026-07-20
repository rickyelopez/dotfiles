{
  lib,
  config,
  hostSpec,
  ...
}:
let
  cfg = config.my.ssh;

  identityFiles = map (file: "${hostSpec.home}/.ssh/${file}") [
    "id_new"
    "id_old"
  ];

  standardHosts = {
    root = [
      "ample"
      "arrakis"
      "cobble"
      "fob"
      "fondor"
      "panama"
      "safeguard"
    ];
    nonroot = [
      "barry"
      "cintra"
      "curiosity"
      "cutiepie"
      "dns-01"
      "erid"
      "ferrix"
      "hubble"
      "hermes"
      "rickhub"
      "sathub"
    ];
  };

  standardHostConfigs = lib.concatMapAttrs (
    user: hosts:
    lib.genAttrs hosts (host: {
      user = user;
      forwardAgent = true;
      identityFile = identityFiles;
    })
  ) standardHosts;
in
{
  options.my.ssh = {
    enable = lib.mkEnableOption "home ssh module.";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {
          controlMaster = "auto";
          controlPath = "${hostSpec.home}/.ssh/sockets/S.%r@%n:%p";
          controlPersist = "20m";
          # Avoids infinite hang if control socket connection interrupted. ex: vpn goes down/up
          serverAliveCountMax = 3;
          serverAliveInterval = 5; # 3 * 5s

          hashKnownHosts = true;
        };
        "github.com" = {
          user = "git";
          forwardAgent = false;
          identitiesOnly = true;
          identityFile = identityFiles;
        };
      }
      // lib.optionalAttrs (!hostSpec.isWork) (
        {
          "git-dg" = {
            hostname = "github.com";
            user = "git";
            forwardAgent = false;
            identitiesOnly = true;
            identityFile = "${hostSpec.home}/.ssh/id_dg";
          };
        }
        // standardHostConfigs
      );
    };

    home.file = {
      ".ssh/sockets/.keep".text = "# Managed by Home Manager";
      ".ssh/id_new.pub".source = lib.custom.relativeToRepoRoot "nix/keys/id_new.pub";
      ".ssh/id_old.pub".source = lib.custom.relativeToRepoRoot "nix/keys/id_old.pub";
    };
  };
}
