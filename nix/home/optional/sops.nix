{ inputs, pkgs, lib, hostSpec, ... }:
let
  home = hostSpec.home;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [ sops ];

  sops = {
    age.keyFile = "${home}/.config/sops/age/keys.txt";
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
    };
  };
}
