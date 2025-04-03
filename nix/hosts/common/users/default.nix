{ pkgs, config, lib, ... }:
let
  user = config.hostSpec.username;
  host = config.hostSpec.hostname;
in
{
  users.users.${user} = {
    name = user;
    shell = pkgs.zsh;
  } // lib.optionalAttrs (!config.hostSpec.isDarwin) {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    just
    git
  ];

  home-manager.users.${user} = import ../../../users/${user}/${host}.nix;
}
