{
  inputs,
  outputs,
  host,
  config,
  lib,
  ...
}:
let
  user = config.hostSpec.username;
  sopsUserPw = config.sops.secrets ? "passwords/${user}";
  sopsHashedPasswordFile = config.sops.secrets."passwords/${user}".path;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops

    ../nixos/${host}
  ];

  networking = {
    hosts = {
      "10.19.21.14" = [
        "dns-01"
        "dns-01.forestroot.elexpedition.com"
      ];
      "10.19.21.18" = [
        "cintra"
        "cintra.forestroot.elexpedition.com"
      ];
      "10.19.21.22" = [
        "fondor"
        "fondor.forestroot.elexpedition.com"
      ];
      "10.19.21.24" = [
        "ferrix"
        "ferrix.forestroot.elexpedition.com"
      ];
      "10.19.21.30" = [
        "fob"
        "fob.forestroot.elexpedition.com"
      ];
      "10.19.21.31" = [
        "sathub"
        "sathub.forestroot.elexpedition.com"
      ];
    };
    domain = lib.mkIf (config.hostSpec ? domain) config.hostSpec.domain;
  };

  nixpkgs.overlays = [ outputs.overlays.default ];
  programs.nix-ld.enable = true;

  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };

  # FIXME: handle uid and gid better
  users = {
    groups.${user} = {
      members = [ user ];
      gid = 1000;
    };

    users.${user} = {
      uid = 1000;
      isNormalUser = true;
      group = toString user;
      extraGroups = lib.flatten [
        (ifTheyExist [
          "dialout"
          "docker"
          "gamemode"
          "networkmanager"
          "wheel"
        ])
      ];
    }
    // (
      if sopsUserPw then
        {
          hashedPasswordFile = sopsHashedPasswordFile;
        }
      else
        {
          initialHashedPassword = "$y$j9T$lejABGwnRzGnhKP7SWz2a/$u8iDH0kOO3TkUbS4mFC3/YO/lb8Yq66FUivEY4BpX.2";
        }
    );

    users.root = {
      openssh.authorizedKeys.keyFiles = [
        (lib.custom.relativeToRoot "keys/id_new.pub")
      ];
    };
  }
  // lib.optionalAttrs sopsUserPw {
    mutableUsers = false;
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never # rollback results in sudo lectures after each reboot, it's somewhat useless anyway
    Defaults pwfeedback # password input feedback - makes typed password visible as asterisks
    Defaults timestamp_timeout=120 # only ask for password every 2h
    # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
    Defaults env_keep+=SSH_AUTH_SOCK
  '';

  # Select locale properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}
