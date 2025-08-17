# this file gets imported if the system is not using standalone home-manager (i.e. nixos or nix-darwin)
{ inputs, pkgs, config, isDarwin, lib, ... }:
let
  user = config.hostSpec.username;
  platform = if isDarwin then "darwin" else "nixos";
  platformModules = "${platform}Modules";
in
{
  imports = [
    inputs.home-manager.${platformModules}.home-manager
    inputs.sops-nix.${platformModules}.sops

    ./${platform}.nix
    ../optional/vim.nix
  ];

  users = {
    users.${user} = {
      name = user;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [
        ../../../keys/id_new.pub
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
    users.${user} = ../../../home;
    sharedModules = map lib.custom.relativeToRoot [ "modules/home-manager" ];
  };
}
