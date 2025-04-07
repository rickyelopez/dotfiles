# this file gets imported if the system is not using standalone home-manager (i.e. nixos or nix-darwin)
{ inputs, lib, pkgs, config, isDarwin, ... }:
let
  user = config.hostSpec.username;
  host = config.hostSpec.hostname;
  platform = if isDarwin then "darwin" else "nixos";
  platformModules = "${platform}Modules";
in
{
  imports = [
    inputs.home-manager.${platformModules}.home-manager

    ./${platform}.nix
  ];

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

  time.timeZone = "America/Los_Angeles";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs; hostSpec = config.hostSpec; };
    users.${user} = import ../../../users/${user}/${host}.nix;
  };
}
