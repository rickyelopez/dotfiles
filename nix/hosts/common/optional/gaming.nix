{ pkgs, lib, config, ... }:
let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
in
{
  programs = {
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        args = [
          "--output-width ${toString monitor.width}"
          "--output-height ${toString monitor.height}"
          "--framerate-limit ${toString (monitor.refreshRate * 2)}"
          "--prefer-output ${monitor.name}"
          "--adaptive-sync"
          "--expose-wayland"
          "--steam"
          "--hdr-enabled"
        ];
      };

      package = pkgs.steam.override {
        extraPkgs = (pkgs: [
          pkgs.gamemode
        ] ++ builtins.attrValues {
          inherit (pkgs.stdenv.cc.cc)
            lib
            ;

          inherit (pkgs)
            keyutils
            gperftools
            ;
        });
      };

      protontricks = {
        enable = true;
        package = pkgs.protontricks;
      };

      extraCompatPackages = [ pkgs.proton-ge-bin ];

    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    # to run steam games in game mode, add the following to the game's properties from within steam
    # gamemoderun %command%
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        #see gamemode man page for settings info
        general = {
          softrealtime = "on";
          inhibit_screensaver = 1;
          renice = 10;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = config.hostSpec.gpu;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };
}
