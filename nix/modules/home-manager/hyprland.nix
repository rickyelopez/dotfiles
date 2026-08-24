{
  pkgs,
  inputs,
  lib,
  config,
  hostSpec,
  my,
  ...
}:
let
  cfg = config.my.hyprland;
in
{
  options.my.hyprland = {
    enable = lib.mkEnableOption "home hyprland module.";
  };

  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  config = lib.mkIf cfg.enable {
    home = {
      file =
        config.lib.file.mkDotfilesSymlinks [
          ".config/hypr/.luarc.json"
          ".config/hypr/binds.lua"
          ".config/hypr/config.lua"
          ".config/hypr/hyprlock.conf"
          ".config/hypr/scripts"
          ".config/hypr/windowrules.lua"
          ".config/uwsm/env"
          ".config/xdg-desktop-portal"
        ]
        // lib.optionalAttrs hostSpec.isLaptop {
          ".config/uwsm/env-hyprland".text = /* bash */ ''
            export AQ_DRM_DEVICES="/dev/dri/igpu:/dev/dri/dgpu"
          '';
        };
    };

    programs = {
      hyprpanel = {
        enable = false;
        # systemd.enable = true;
        settings = {
          bar = {
            network.label = false;
            notifications.show_total = true;
            customModules.cpuTemp.sensor = "/sys/class/hwmon/hwmon2/temp1_input";
            # customModules.netstat.networkInterface = "wlp60s0";
            layouts = {
              "0" = {
                "left" = [
                  "dashboard"
                  "workspaces"
                  "windowtitle"
                ];
                "middle" = [ "media" ];
                "right" = lib.flatten [
                  "hypridle"
                  "volume"
                  # "network"
                  # "bluetooth"
                  (lib.optionalString hostSpec.isLaptop "battery")
                  "cputemp"
                  "systray"
                  "clock"
                  "notifications"
                ];
              };
              "*" = {
                "left" = [
                  "dashboard"
                  "workspaces"
                  "windowtitle"
                ];
                "middle" = [ ];
                "right" = [ ];
              };
            };
          };
          menus = {
            clock.weather.enabled = false;
            dashboard = {
              powermenu.logout = "uwsm stop";
              stats.enable_gpu = false;
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
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      systemd.enable = false;
      package = null;
      portalPackage = null;
      extraConfig = ''
        require("config")
        require("binds")
        require("windowrules")
      '';
      settings = {
        monitor = (
          map (m: {
            disabled = !m.enabled;
            output = m.name;
            mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
            scale = 1;
            transform = 0;
            vrr = m.vrr;
          }) my.monitors
        );

        workspace_rule = (
          map (m: {
            workspace = m.workspace;
            monitor = m.name;
            default = true;
            persistent = true;
          }) (builtins.filter (m: m ? "workspace") my.monitors)
        );

        config = {
          plugin = {
            csgo_vulkan_fix = {
              fix_mouse = true;
            };
          };
        };

        "plugin.csgo_vulkan_fix.vkfix_app" =
          let
            monitor = (builtins.elemAt (builtins.filter (m: m.primary) my.monitors) 0);
          in
          {
            # NOT a regex! This is a string and has to exactly match initial_class
            app = "cs2";
            w = monitor.width;
            h = monitor.height;
          };

        #   animations = {
        #     enabled = true;
        #     bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        #     animation = [
        #       "windows    , 1   , 7  , myBezier"
        #       "windowsOut , 1   , 7  , default , popin 80%"
        #       "border     , 1   , 10 , default"
        #       "borderangle, 1   , 8  , default"
        #       "fade       , 1   , 7  , default"
        #       "workspaces , 1   , 6  , default"
        #     ];
        #   };
      };
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.csgo-vulkan-fix
      ];
    };

    services = {
      blueman-applet.enable = true;
      hypridle = {
        enable = true;
        settings = {
          general = {
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "pidof hyprlock || hyprlock --grace 0";
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            {
              timeout = 500;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 1200;
              on-timeout = "systemctl suspend";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
      wpaperd = {
        enable = true;
        settings = {
          any = {
            path = "~/Nextcloud/Media/Wallpapers/1694344616904955.jpg";
          };
        };
      };

      wayle = {
        enable = true;

        settings = {
          bar = {
            layout = [
              {
                center = [ "clock" ];
                left = [
                  "dashboard"
                  {
                    modules = [
                      "cpu"
                      "ram"
                    ];
                    name = "Stats";
                  }
                  "hyprland-workspaces"
                  "media"
                ];
                monitor = "*";
                right = [
                  "idle-inhibit"
                  "battery"
                  {
                    modules = [
                      "volume"
                      "microphone"
                    ];
                    name = "Audio";
                  }
                  "systray"
                  {
                    modules = [
                      "network"
                      "bluetooth"
                    ];
                    name = "Networking";
                  }
                  "notifications"
                ];
                show = true;
              }
            ];
            scale = 0.85;
          };
          general = {
            font-mono = "BlexMono Nerd Font Mono";
          };
          modules = {
            bluetooth = {
              label-show = false;
            };
            clock = {
              format = "%a %b %d %I:%M:%S %p";
            };
            cpu = {
              format = "{{ percent }}% {{ temp_c }}°C";
            };
            dashboard = {
              dropdown-logout-command = "uwsm stop";
            };
            hyprland-workspaces = {
              workspace-ignore = [ "-99" ];
            };
            media = {
              players-ignored = [ "brave.instance*" ];
            };
            systray = {
              icon-scale = 1.1;
              internal-padding = 0.25;
            };
          };
          wallpaper = {
            engine-enabled = false;
          };
        };
      };
    };
  };
}
