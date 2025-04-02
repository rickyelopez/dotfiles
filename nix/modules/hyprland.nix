{ pkgs, inputs, config, hostSpec, ... }:
let
  home = hostSpec.home;
in
{
  home = {
    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/hypr/hyprland.conf".source = mkLink "${home}/dotfiles/.config/hypr/hyprland.conf";
      ".config/hypr/hyprlock.conf".source = mkLink "${home}/dotfiles/.config/hypr/hyprlock.conf";
      ".config/hypr/scripts".source = mkLink "${home}/dotfiles/.config/hypr/scripts";
    };
  };
  programs = {
    hyprpanel = {
      enable = true;
      overlay.enable = true;
      # systemd.enable = true;
      settings = {
        bar = {
          network.label = false;
          notifications.show_total = true;
          customModules.cpuTemp.sensor = "/sys/class/hwmon/hwmon2/temp1_input";
          customModules.netstat.networkInterface = "wlp0s20f3";
        };
        menus = {
          clock.weather.enabled = false;
          dashboard = {
            powermenu.logout = "uwsm stop";
            stats.enable_gpu = true;
            shortcuts.enabled = false;
            directories.enabled = false;
          };
          power.lowBatteryNotification = true;
        };
        theme = {
          bar.outer_spacing = "0.2em";
          font.size = "1.0rem";
        };
      };
      layout = {
        "bar.layouts" = {
          "0" = {
            "left" = [ "dashboard" "workspaces" "windowtitle" ];
            "middle" = [ "media" ];
            "right" = [
              "volume"
              "network"
              "bluetooth"
              "battery"
              "cputemp"
              "systray"
              "clock"
              "notifications"
            ];
          };
          "1" = {
            "left" = [ "dashboard" "workspaces" "windowtitle" ];
            "middle" = [ "media" ];
            "right" = [ "volume" "clock" "notifications" ];
          };
          "2" = {
            "left" = [ "dashboard" "workspaces" "windowtitle" ];
            "middle" = [ "media" ];
            "right" = [ "volume" "clock" "notifications" ];
          };
        };
      };
    };
  };

  services = {
    hyprpaper = {
      enable = true;
      package = inputs.hyprpaper.packages.${pkgs.system}.hyprpaper;
      settings = {
        preload =
          [
            "~/Nextcloud/Media/Wallpapers/1643793713226.jpg"
            "~/Nextcloud/Media/Wallpapers/1694344616904955.jpg"
            "~/Nextcloud/Media/Wallpapers/Dog Watcher.jpg"
          ];

        wallpaper = [
          ",~/Nextcloud/Media/Wallpapers/1643793713226.jpg"
        ];
      };
    };
  };

  imports = [
    inputs.hyprpanel.homeManagerModules.hyprpanel
  ];
}
