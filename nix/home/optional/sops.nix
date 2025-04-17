{ inputs, pkgs, lib, hostSpec, ... }:
let
  home = hostSpec.home;
  ageFolder = "${home}/.config/sops/age";
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [ sops ];
  sops = {
    age.keyFile = "${ageFolder}/keys.txt";
    defaultSopsFile = ../../../secrets.yaml;
    validateSopsFiles = false;

    secrets = {
      "private_keys/new" = {
        path = "${home}/.ssh/id_new";
      };

      "private_keys/old" = {
        path = "${home}/.ssh/id_old";
      };
    } // lib.optionalAttrs (hostSpec.isWork) {
      "private_keys/zip" = {
        path = "${home}/.ssh/id_zip";
      };
    } // lib.optionalAttrs (!hostSpec.isWork) {
      "private_keys/dg" = {
        path = "${home}/.ssh/id_dg";
      };
    };
  };
}
