{
  inputs,
  pkgs,
  lib,
  config,
  hostSpec,
  ...
}:
let
  cfg = config.my.sops;
  home = hostSpec.home;
  ageFolder = "${home}/.config/sops/age";
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options.my.sops = {
    enable = lib.mkEnableOption "home sops-nix module.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ sops ];
    sops = {
      age.keyFile = "${ageFolder}/keys.txt";
      defaultSopsFile = lib.custom.relativeToRepoRoot "secrets.yaml";
      validateSopsFiles = false;

      secrets = {
        "private_keys/new" = {
          path = "${home}/.ssh/id_new";
        };

        "private_keys/old" = {
          path = "${home}/.ssh/id_old";
        };
      }
      // lib.optionalAttrs (hostSpec.isWork) {
        "private_keys/zip" = {
          path = "${home}/.ssh/id_zip";
        };
      }
      // lib.optionalAttrs (!hostSpec.isWork) {
        "private_keys/dg" = {
          path = "${home}/.ssh/id_dg";
        };
      };
    };
  };
}
