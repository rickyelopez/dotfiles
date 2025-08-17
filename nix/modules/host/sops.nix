{ config, lib, ... }:
let
  cfg = config.my.sops;
  home = config.hostSpec.home;
  user = config.hostSpec.username;
  ageFolder = "${home}/.config/sops/age";
in
{
  options.my.sops = {
    enable = lib.mkEnableOption "host sops module.";
  };

  config = lib.mkIf cfg.enable {
    sops = {
      age.keyFile = "${ageFolder}/keys.txt";
      defaultSopsFile = lib.custom.relativeToRepoRoot "secrets.yaml";
      validateSopsFiles = false;

      secrets = {
        "passwords/${user}" = {
          neededForUsers = true;
        };
      };
    };

    system.activationScripts.sopsSetAgeKeyOwnership =
      let
        user = config.users.users.${config.hostSpec.username}.name;
        group = config.users.users.${config.hostSpec.username}.group;
      in
      ''
        mkdir -p ${ageFolder} || true
        chown ${user}:${group} ${home}/.config
        chown -R ${user}:${group} ${home}/.config/sops
      '';
  };
}
