{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.hostSpec = lib.mkOption {
    type = lib.types.submodule {
      options = {
        hostname = lib.mkOption {
          type = lib.types.str;
        };

        username = lib.mkOption {
          type = lib.types.str;
        };

        networking = lib.mkOption {
          type = lib.types.submodule {
            options = {
              addresses = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    ipv4 = lib.mkOption {
                      type = lib.types.str;
                    };

                    ipv6 = lib.mkOption {
                      type = lib.types.str;
                    };
                  };

                };
              };

              nameservers = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };

              domain = lib.mkOption {
                type = lib.types.str;
                default = "";
              };
            };
          };
        };

        home = lib.mkOption {
          description = "The user's home directory";
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

        hasWifi = lib.mkOption {
          description = "Whether or not the host has WiFi";
          type = lib.types.bool;
          default = false;
        };

        isLaptop = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        isServer = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        isWork = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        isDarwin = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        isStandaloneHm = lib.mkOption {
          description = "Used to indicate that the given config is a standalone home manager config (no nixosConfiguration or darwinConfiguration)";
          type = lib.types.bool;
          default = false;
        };

        isHeadless = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };
    };
  };
}
