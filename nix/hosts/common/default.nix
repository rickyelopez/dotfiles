# this file gets imported if the system is not using standalone home-manager (i.e. nixos or nix-darwin)
{ inputs, pkgs, config, lib, ... }:
let
  user = config.hostSpec.username;
in
{
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

  environment.systemPackages = with pkgs; [
    just
    git
  ];

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
