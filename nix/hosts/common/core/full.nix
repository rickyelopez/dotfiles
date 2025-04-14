# this file gets imported if the system is not using standalone home-manager (i.e. nixos or nix-darwin)
{ inputs, lib, pkgs, config, isDarwin, ... }:
let
  user = config.hostSpec.username;
  host = config.hostSpec.hostname;
  platform = if isDarwin then "darwin" else "nixos";
  platformModules = "${platform}Modules";
  sopsHashedPasswordFile =
    if config.sops.secrets ? "passwords/${user}"
    then config.sops.secrets."passwords/${user}".path
    else "";
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  imports = [
    inputs.home-manager.${platformModules}.home-manager
    inputs.sops-nix.${platformModules}.sops

    ./${platform}.nix
  ];

  users = {
    users.${user} = {
      name = user;
      shell = pkgs.zsh;
    } // lib.optionalAttrs (!config.hostSpec.isDarwin) {
      isNormalUser = true;
      extraGroups = lib.flatten [
        (ifTheyExist [
          "dialout"
          "docker"
          "gamemode"
          "networkmanager"
          "wheel"
        ])
      ];
      hashedPasswordFile = sopsHashedPasswordFile;
    };

    users.root = lib.mkIf (!config.hostSpec.isDarwin) {
      # shell = pkgs.zsh;
      hashedPasswordFile = sopsHashedPasswordFile;
    };
  } // lib.optionalAttrs (!config.hostSpec.isDarwin) { mutableUsers = true; };

  programs = {
    zsh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    just
    git
  ];

  networking.hostName = config.hostSpec.hostname; # Define your hostname.

  time.timeZone = "America/Los_Angeles";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs; hostSpec = config.hostSpec; monitors = config.monitors; };
    users.${user} = import ../../../home/users/${user}/${host}.nix;
  };
}
