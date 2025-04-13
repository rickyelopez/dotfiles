{ pkgs, config, ... }: {
  programs = {
    steam = {
      enable = true;
      protontricks = {
        enable = true;
        package = pkgs.protontricks;
      };
      extraCompatPackages = [ pkgs.proton-ge-bin ];

    };
    #gamescope launch args set dynamically in home/<user>/common/optional/gaming
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    # to run steam games in game mode, add the following to the game's properties from within steam
    # gamemoderun %command%
    gamemode = {
      enable = true;
      settings = {
        #see gamemode man page for settings info
        general = {
          softrealtime = "on";
          inhibit_screensaver = 1;
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
