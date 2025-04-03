# this file gets imported if the system is not using standalone home-manager (i.e. nixos or nix-darwin)
{ inputs, pkgs, config, isDarwin, ... }:
let
  platform = if isDarwin then "darwin" else "nixos";
  platformModules = "${platform}Modules";
in
{
  imports = [
    inputs.home-manager.${platformModules}.home-manager

    ./${platform}.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs; hostSpec = config.hostSpec; };
  };
}
