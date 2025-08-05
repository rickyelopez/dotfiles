{ lib, hostSpec, ... }:
let
  identityFiles = [ "id_new" "id_old" ];
  standardHosts = [
    { user = "nonroot"; host = "cintra"; }
    { user = "nonroot"; host = "dns-01"; }
    { user = "nonroot"; host = "ferrix"; }
    { user = "nonroot"; host = "sathub"; }
    { user = "root"; host = "fob"; }
    { user = "root"; host = "fondor"; }
    { user = "root"; host = "panama"; }
  ];
  standardHostConfigs = lib.attrsets.mergeAttrsList (
    lib.lists.map
      (cfg: {
        "${cfg.host}" = {
          # match = "host ${host},${host}.${config.hostSpec.domain}";
          user = cfg.user;
          forwardAgent = true;
          identityFile = lib.lists.forEach identityFiles (file: "${hostSpec.home}/.ssh/${file}");
        };
      })
      standardHosts
  );
in
{
  programs.ssh = {
    enable = true;

    controlMaster = "auto";
    controlPath = "${hostSpec.home}/.ssh/sockets/S.%r@%h:%p";
    controlPersist = "20m";
    # Avoids infinite hang if control socket connection interrupted. ex: vpn goes down/up
    serverAliveCountMax = 3;
    serverAliveInterval = 5; # 3 * 5s

    hashKnownHosts = true;
    addKeysToAgent = "yes";

    matchBlocks = {
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
}
