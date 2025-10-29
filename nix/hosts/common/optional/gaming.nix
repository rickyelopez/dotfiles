{
  pkgs,
  lib,
  config,
  ...
}:
let
  monitor = lib.head (lib.filter (m: m.primary) config.my.monitors);
in
{
  # https://github.com/fufexan/nix-gaming/blob/master/modules/platformOptimizations.nix
  boot.kernel.sysctl = {
    # 20-shed.conf
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    # 20-net-timeout.conf
    # This is required due to some games being unable to reuse their TCP ports
    # if they're killed and restarted quickly - the default timeout is too large.
    "net.ipv4.tcp_fin_timeout" = 5;
    # 30-splitlock.conf
    # Prevents intentional slowdowns in case games experience split locks
    # This is valid for kernels v6.0+
    "kernel.split_lock_mitigate" = 0;
    # 30-vm.conf
    # USE MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
    # see comment in include/linux/mm.h in the kernel tree.
    "vm.max_map_count" = 2147483642;
  };

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

      extraPackages = with pkgs; [
        gamemode
        gamescope
      ];
      protontricks.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];

      # package = pkgs.steam.override {
      #   extraPkgs = (pkgs: [
      #     pkgs.gamemode
      #   ] ++ builtins.attrValues {
      #     inherit (pkgs.stdenv.cc.cc)
      #       lib
      #       ;

      #     inherit (pkgs)
      #       keyutils
      #       gperftools
      #       ;
      #   });
      # };

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
