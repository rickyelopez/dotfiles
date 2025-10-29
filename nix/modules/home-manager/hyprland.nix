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
          ".config/hypr/hyprlock.conf"
          ".config/hypr/scripts"
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
        enable = true;
        # systemd.enable = true;
        settings = {
          bar = {
            network.label = false;
            notifications.show_total = true;
            customModules.cpuTemp.sensor = "/sys/class/hwmon/hwmon2/temp1_input";
            customModules.netstat.networkInterface = "wlp0s20f3";
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
                  "network"
                  "bluetooth"
                  (lib.optionalString hostSpec.hasBattery "battery")
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
      systemd.enable = false;
      package = null;
      portalPackage = null;
      settings = {
        "$mainMod" = "SUPER";
        "$terminal" = lib.getExe pkgs.ghostty;
        "$fileManager" = lib.getExe pkgs.xfce.thunar;
        "$screenshot" =
          ''${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" - | ${lib.getExe pkgs.swappy} -f -'';

        monitor =
          (map (
            m:
            "${m.name},${
              if m.enabled then
                "${toString m.width}x${toString m.height}@${toString m.refreshRate}"
                + ",${toString m.x}x${toString m.y},1"
                + ",transform,${toString m.transform}"
                + ",vrr,${toString m.vrr}"
              else
                "disable"
            }"
          ) my.monitors)
          ++ [ ",preferred,auto,1" ];

        workspace = (
          map (m: "${m.workspace}, monitor:${m.name}, default:true, persistent:true") (
            builtins.filter (m: m ? "workspace") my.monitors
          )
        );

        input = {
          accel_profile = "flat";
          follow_mouse = 1;
          kb_layout = "us";
          kb_options = "ctrl:nocaps,fkeys:basic_13-24";
          natural_scroll = false;
          numlock_by_default = true;
          repeat_delay = 175;
          repeat_rate = 35;
          sensitivity = 0.3;
          touchpad = {
            clickfinger_behavior = true;
            disable_while_typing = false;
            scroll_factor = 0.3;
          };
        };

        cursor = {
          no_hardware_cursors = true;
        };

        general = {
          allow_tearing = true;
          border_size = 1;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          gaps_in = 2;
          gaps_out = 2;
          layout = "dwindle";
        };

        decoration = {
          blur = {
            enabled = false;
            new_optimizations = true;
            passes = 1;
            size = 3;
          };
          rounding = 5;
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows    , 1   , 7  , myBezier"
            "windowsOut , 1   , 7  , default , popin 80%"
            "border     , 1   , 10 , default"
            "borderangle, 1   , 8  , default"
            "fade       , 1   , 7  , default"
            "workspaces , 1   , 6  , default"
          ];
        };

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # you probably want this
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_status = "master";
        };

        gesture = [
          "3, horizontal, workspace"
        ];

        gestures = {
          workspace_swipe_invert = false;
        };

        misc = {
          disable_hyprland_logo = true;
        };

        exec-once = [
          # "dbus-update-activation-environment --systemd --all"
          "systemctl --user start hyprpolkitagent"
          "systemctl --user start hyprpaper"
          "uwsm app -- hyprpanel" # The top bar
        ];

        windowrulev2 = [
          "float            , class:^org.pulseaudio.pavucontrol$"
          "float            , class:blueman-manager"
          "float            , class:^nm-connection-editor$"
          "float            , class:^[Tt]hunar$"
          "size 1200 600    , class:^[Tt]hunar$"
          "float            , title:^btop$"
          "float            , title:^KCalc$"
          "float            , title:^Qalculate!$"
          "float            , class:^steam$"

          "float            , class:^discord$"
          "workspace 6      , class:^discord$"
          "size 1325 685    , class:^discord$"

          "float            , title:^Nextcloud$"
          "move 75.5% 30    , title:^Nextcloud$"

          "float            , title:^Ferdium$"
          "workspace special, title:^Ferdium$"
          "move 884 50      , title:^Ferdium$"
          "size 1033 1027   , title:^Ferdium$"

          "float            , title:^ncspot$"
          "workspace special, title:^ncspot$"
          "move 2% 5%       , title:^ncspot$"

          "animation popin  , class:^$fileManager$"

          "animation popin  , class:^Brave-browser$"
          "float            , class:^Brave-browser$, title:^_crx_.*$" # bitwarden popups
          "float            , class:^Bitwarden$" # bitwarden-desktop

          "float            , title:^Dashboard | uckg2p-cali - Brave$" # camera monitoring
          "move 2562 667    , title:^Dashboard | uckg2p-cali - Brave$"
          "size 2552 772    , title:^Dashboard | uckg2p-cali - Brave$"

          "float            , class:^Rofi$"
          "animation slide  , class:^Rofi$"
        ];

        bind = [
          # hyprland stuff
          "$mainMod, Q, killactive,"
          # "$mainMod, M, uwsm stop,"
          "$mainMod, V, togglefloating,"
          "$mainMod, P, pseudo," # dwindle
          "$mainMod, E, togglesplit" # dwindle
          "$mainMod, F, fullscreen"

          # general shortcuts
          "$mainMod, RETURN, exec, uwsm-app -- $terminal" # terminal emulator
          "$mainMod, S     , exec, uwsm-app -- $screenshot" # screenshot
          "$mainMod, L     , exec, uwsm-app -- hyprlock" # lockscreen
          "ALT_L   , SPACE , exec, rofi -combi -show" # rofi
          "ALT_L   , E     , exec, uwsm-app -- $fileManager" # file manager

          "$mainMod      , G    , togglegroup"
          "ALT_L         , tab  , changegroupactive"
          "$mainMod      , grave, togglespecialworkspace"
          "$mainMod SHIFT, grave, movetoworkspace, special"

          # Move focus with mainMod + arrow keys
          "$mainMod, h, movefocus, l"
          "$mainMod, j, movefocus, d"
          "$mainMod, k, movefocus, u"
          "$mainMod, l, movefocus, r"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Workspaces related
          "$mainMod SHIFT, l  , workspace, e+1"
          "$mainMod SHIFT, h  , workspace, e-1"
          "$mainMod      , tab, workspace, m+1"
          "$mainMod SHIFT, tab, workspace, m-1"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up  , workspace, e-1"

          # "$mainMod, UP, overview:toggle, all"

          "$mainMod SHIFT, O, dpms, on"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod      , mouse:272, movewindow" # mainMod + click to move
          "$mainMod      , mouse:273, resizewindow" # mainMod + right click to resize
          "$mainMod SHIFT, mouse:272, resizewindow" # mainMod + Shift + click to resize
        ];

        binde =
          let
            pamixer = lib.getExe pkgs.pamixer;
            playerctl = lib.getExe pkgs.playerctl;
            brightnessctl = lib.getExe pkgs.brightnessctl;
          in
          [
            "     , XF86AudioRaiseVolume, exec, ${pamixer} -i 5"
            "     , XF86AudioLowerVolume, exec, ${pamixer} -d 5"
            "SHIFT, XF86AudioRaiseVolume, exec, ${pamixer} --default-source -i 5"
            "SHIFT, XF86AudioLowerVolume, exec, ${pamixer} --default-source -d 5"
            "     , XF86AudioMute       , exec, ${pamixer} -t"
            "SHIFT, XF86AudioMute       , exec, ${pamixer} --default-source -t"
            "     , XF86AudioPlay       , exec, ${playerctl} play-pause"
            "     , XF86AudioPrev       , exec, ${playerctl} previous"
            "     , XF86AudioNext       , exec, ${playerctl} next"
          ]
          ++ lib.optionals hostSpec.isLaptop [
            "     , XF86Calculator      , exec, qalculate-gtk"

            # keyboard brightness buttons
            "     , XF86MonBrightnessUp  , exec, ${brightnessctl} set 5%+"
            "     , XF86MonBrightnessDown, exec, ${brightnessctl} --min-value=1 set 5%-"
            "SHIFT, XF86MonBrightnessUp  , exec, ${brightnessctl} set 1%+"
            "SHIFT, XF86MonBrightnessDown, exec, ${brightnessctl} --min-value=1 set 1%-"
            "     , Print , exec, $screenshot"
            # "binde =      , F9 , exec, cmd"

          ];

        bindl =
          [ ]
          ++ lib.optionals hostSpec.isLaptop [
            # lid switch lock + suspend
            ", switch:on:Lid Switch, exec, systemctl suspend; pidof hyprlock || uwsm-app -- hyprlock --immediate & disown"
          ];

        plugin = {
          csgo-vulkan-fix = {
            # res_w = 1920;
            # res_h = 1200;
            res_w = 2560;
            res_h = 1440;

            # NOT a regex! This is a string and has to exactly match initial_class
            class = "cs2";

            # Whether to fix the mouse position. A select few apps might be wonky with this.
            fix_mouse = true;
          };
        };

      };
      extraConfig = " ";
      plugins = [
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
        inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
        # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
      ];
    };

    services = {
      blueman-applet.enable = false; # hyprpanel has a nice bluetooth menu
      hypridle = {
        enable = true;
        settings = {
          general = {
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "pidof hyprlock || hyprlock --immediate";
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
      hyprpaper = {
        enable = true;
        package = inputs.hyprpaper.packages.${pkgs.system}.hyprpaper;
        settings = {
          preload = [
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
  };
}
