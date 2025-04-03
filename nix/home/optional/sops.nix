{ inputs, pkgs, ... }: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.packages = with pkgs; [ sops ];

  sops = {
    age.keyFile = "/home/ricclopez/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets.yaml;
    validateSopsFiles = false;

    secrets = {
      "private_keys/new" = {
        path = "/home/ricclopez/.ssh/id_new";
      };
      "private_keys/old" = {
        path = "/home/ricclopez/.ssh/id_old";
      };
    };
  };
}
