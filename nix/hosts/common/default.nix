# this file gets imported if the system is not using standalone home-manager (i.e. nixos or nix-darwin)
{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  user = config.hostSpec.username;
in
{
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      trusted-users = [ user ];
      trusted-substituters = [ "https://nix-community.cachix.org/" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };
  };

  users = {
    users.${user} = {
      name = user;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [
        (lib.custom.relativeToRoot "keys/id_new.pub")
      ];
    };
  };

  programs = {
    zsh.enable = true;
  };

  networking.hostName = config.hostSpec.hostname;

  time.timeZone = "America/Los_Angeles";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs pkgs;
      hostSpec = config.hostSpec;
      my = config.my;
    };
    users.${user} = lib.custom.relativeToRoot "home/";
    sharedModules = map lib.custom.relativeToRoot [ "modules/home-manager" ];
  };

  my = {
    vim.enable = true;
  };
}
