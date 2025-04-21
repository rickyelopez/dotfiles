# this file gets imported if the system is not using standalone home-manager (i.e. nixos or nix-darwin)
{ inputs, lib, pkgs, config, isDarwin, ... }:
let
  user = config.hostSpec.username;
  host = config.hostSpec.hostname;
  platform = if isDarwin then "darwin" else "nixos";
  platformModules = "${platform}Modules";
  sopsUserPw = config.sops.secrets ? "passwords/${user}";
  sopsHashedPasswordFile = config.sops.secrets."passwords/${user}".path;
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
      initialHashedPassword = "$y$j9T$lejABGwnRzGnhKP7SWz2a/$u8iDH0kOO3TkUbS4mFC3/YO/lb8Yq66FUivEY4BpX.2";
      openssh.authorizedKeys.keyFiles = [
        ../../../keys/id_new.pub
      ];
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
    } // lib.optionalAttrs sopsUserPw {
      hashedPasswordFile = sopsHashedPasswordFile;
    };

    users.root = {
      openssh.authorizedKeys.keyFiles = [
        ../../../keys/id_new.pub
      ];
    } // lib.optionalAttrs sopsUserPw {
      # shell = pkgs.zsh;
      hashedPasswordFile = sopsHashedPasswordFile;
    };
  } // lib.optionalAttrs sopsUserPw {
    mutableUsers = false;
  };

  programs = {
    zsh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    just
    git
  ];

  networking.hostName = config.hostSpec.hostname; # Define your hostname.
  networking.domain = lib.mkIf (config.hostSpec ? domain) config.hostSpec.domain;

  time.timeZone = "America/Los_Angeles";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs; hostSpec = config.hostSpec; monitors = config.monitors; };
    users.${user} = import ../../../home/users/${user}/${host}.nix;
  };
}
