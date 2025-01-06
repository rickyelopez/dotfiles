{ pkgs, inputs, home, config, lib, user, ... }:
{
  home = {
    packages = with pkgs; [
      brave
      calibre
      ferdium
      ghostty
      rofi
      vlc
    ];

    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/Kvantum".source = mkLink "${home}/dotfiles/.config/Kvantum";
      ".config/hypr/hyprland.conf".source = mkLink "${home}/dotfiles/.config/hypr/hyprland.conf";
      ".config/hypr/hyprlock.conf".source = mkLink "${home}/dotfiles/.config/hypr/hyprlock.conf";
      ".config/hypr/scripts".source = mkLink "${home}/dotfiles/.config/hypr/scripts";
      ".config/qt5ct".source = mkLink "${home}/dotfiles/.config/qt5ct";
      ".config/qt6ct".source = mkLink "${home}/dotfiles/.config/qt6ct";
      ".config/rofi".source = mkLink "${home}/dotfiles/.config/rofi";
      ".config/uwsm".source = mkLink "${home}/dotfiles/.config/uwsm";
      ".config/xdg-desktop-portal".source = mkLink "${home}/dotfiles/.config/xdg-desktop-portal";
    };
    pointerCursor = {
      gtk.enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-qt;
      size = 24;
    };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Adwaita";
      size = 24;
    };
    # gtk2.configLocation = "";
    gtk3 = {
      bookmarks = [
        "file:///home/${user}/Nextcloud"
      ];
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    iconTheme.name = "Tokyonight-Light";
    theme = {
      package = pkgs.tokyonight-gtk-theme;
      name = "Tokyonight-Dark";
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
    ../../home.nix
  ];
}
