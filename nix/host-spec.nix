{ config
, pkgs
, lib
, ...
}:
{
  options.hostSpec = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "The username of the host";
    };
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the host";
    };
    email = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "The email of the user";
    };
    work = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "An attribute set of work-related information if isWork is true";
    };
    networking = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "An attribute set of networking information";
    };
    wifi = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate if a host has wifi";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain of the host";
    };
    userFullName = lib.mkOption {
      type = lib.types.str;
      description = "The full name of the user";
    };
    home = lib.mkOption {
      type = lib.types.str;
      description = "The home directory of the user";
      default =
        let
          user = config.hostSpec.username;
        in
        if pkgs.stdenv.isLinux then "/home/${user}" else "/Users/${user}";
    };
    gpu = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      description = "X as in /sys/class/drm/cardX";
      default = null;
    };

    isServer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a server host";
    };
    isWork = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a host that uses work resources";
    };
    isDarwin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a darwin host";
    };
    isStandaloneHm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a host that is using standalone home-manager (not nixos or nix-darwin)";
    };
    isHeadless = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate that a host is headless (used via ssh only)";
    };
    useYubikey = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate if the host uses a yubikey";
    };
  };
}
