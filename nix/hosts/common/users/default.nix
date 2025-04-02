{ pkgs, config, ... }:
let
  user = config.hostSpec.username;
  host = config.hostSpec.hostname;
in
{
  users.users.${user} = {
    name = user;
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    just
    git
  ];

  home-manager.users.${user} = import ../../../users/${user}/${host}.nix;
}
