{ config, ... }:
let
  home = config.hostSpec.home;
  user = config.hostSpec.username;
  ageFolder = "${home}/.config/sops/age";
in
{
  fileSystems."/home".neededForBoot = true;

  sops = {
    age.keyFile = "${ageFolder}/keys.txt";
    defaultSopsFile = ../../../../secrets.yaml;
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
      chown -R ${user}:${group} ${home}/.config
    '';
}
