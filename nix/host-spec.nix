{ config
, pkgs
, lib
, ...
}:
{
  options.hostSpec = {
    username = lib.mkOption {
      description = "The username of the host";
      type = lib.types.str;
    };
    hostname = lib.mkOption {
      description = "The hostname of the host";
      type = lib.types.str;
    };
    email = lib.mkOption {
      description = "The email of the user";
      type = lib.types.attrsOf lib.types.str;
    };
    work = lib.mkOption {
      description = "An attribute set of work-related information if isWork is true";
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };
    networking = lib.mkOption {
      description = "An attribute set of networking information";
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };
    wifi = lib.mkOption {
      description = "Used to indicate if a host has wifi";
      type = lib.types.bool;
      default = false;
    };
    domain = lib.mkOption {
      description = "The domain of the host";
      type = lib.types.str;
      default = "";
    };
    userFullName = lib.mkOption {
      description = "The full name of the user";
      type = lib.types.str;
    };
    home = lib.mkOption {
      description = "The home directory of the user";
      type = lib.types.str;
      default =
        let
          user = config.hostSpec.username;
        in
        if pkgs.stdenv.isLinux then "/home/${user}" else "/Users/${user}";
    };
    gpu = lib.mkOption {
      description = "X as in /sys/class/drm/cardX";
      type = lib.types.nullOr lib.types.int;
      default = null;
    };
    isLaptop = lib.mkOption {
      description = "Whether this host is a laptop";
      type = lib.types.bool;
      default = false;
    };
    hasBattery = lib.mkOption {
      description = "Whether this host has a battery (e.g. laptop)";
      type = lib.types.bool;
      default = config.hostSpec.isLaptop;
    };

    isServer = lib.mkOption {
      description = "Used to indicate a server host";
      type = lib.types.bool;
      default = false;
    };
    isWork = lib.mkOption {
      description = "Used to indicate a host that uses work resources";
      type = lib.types.bool;
      default = false;
    };
    isDarwin = lib.mkOption {
      description = "Used to indicate a darwin host";
      type = lib.types.bool;
      default = false;
    };
    isStandaloneHm = lib.mkOption {
      description = "Used to indicate a host that is using standalone home-manager (not nixos or nix-darwin)";
      type = lib.types.bool;
      default = false;
    };
    isHeadless = lib.mkOption {
      description = "Used to indicate that a host is headless (used via ssh only)";
      type = lib.types.bool;
      default = false;
    };
    useYubikey = lib.mkOption {
      description = "Used to indicate if the host uses a yubikey";
      type = lib.types.bool;
      default = false;
    };
  };
}
