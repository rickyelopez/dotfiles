{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.yazi;
in
{
  options.my.yazi = {
    enable = lib.mkEnableOption "home yazi module.";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      yazi = {
        enable = true;
        enableZshIntegration = true;
        initLua = builtins.readFile (lib.custom.relativeToRepoRoot ".config/yazi/init.lua");

        keymap = {
          mgr.prepend_keymap = [
            {
              on = [
                "g"
                "d"
              ];
              run = "cd ~/dotfiles";
              desc = "Goto ~/dotfiles";
            }
            {
              on = "<C-p>";
              run = "paste";
              desc = "Paste (not smart)";
            }
            {
              on = "F";
              run = "plugin smart-filter";
              desc = "Smart filter";
            }
            {
              on = [
                "c"
                "m"
              ];
              run = "plugin chmod";
              desc = "Chmod on selected files";
            }
            {
              on = [
                "c"
                "f"
              ];
              run = "plugin flatten";
              desc = "Flatten selected dirs";
            }
            {
              on = [
                "c"
                "e"
              ];
              run = "plugin select-empty";
              desc = "Select empty dirs";
            }
            {
              on = [
                "d"
                "u"
              ];
              run = "plugin restore";
              desc = "Restore last deleted files/folders";
            }
            {
              on = "p";
              run = "plugin augment-command -- paste";
              desc = "Paste (smart)";
            }
            {
              on = "P";
              run = "plugin augment-command -- paste --force";
              desc = "Paste yanked files (smart) (overwrite if the destination exists)";
            }
            {
              on = "a";
              run = "plugin augment-command -- create";
              desc = "Create a file or directory";
            }
            {
              on = [
                "d"
                "d"
              ];
              run = "plugin augment-command -- remove";
              desc = "Trash selected files";
            }
            {
              on = [
                "d"
                "D"
              ];
              run = "plugin augment-command -- remove --permanently";
              desc = "Permanently delete selected files";
            }
          ]
          ++ builtins.map (num: {
            on = "${toString num}";
            run = "plugin augment-command -- tab_switch ${toString (num - 1)}";
            desc = "Switch to tab ${toString num}";
          }) (lib.range 1 9);
        };

        plugins = {
          augment-command = pkgs.yaziPlugins.augment-command;
          chmod = pkgs.yaziPlugins.chmod;
          restore = pkgs.yaziPlugins.restore;
          smart-filter = pkgs.yaziPlugins.smart-filter;
        };

        settings = {
          mgr = {
            show_hidden = true;
            show_symlink = true;
          };
          opener = {
            edit = [
              {
                run = "nvim \"$@\"";
                desc = "nvim";
                block = true;
              }
              {
                run = "nvr --remote-silent \"$@\"";
                desc = "nvr";
              }
              {
                run = "$${EDITOR:-vim} \"$@\"";
                desc = "$EDITOR";
                block = true;
                for = "linux";
              }
            ];
          };
          play = [
            {
              run = "vlc \"$@\"";
              desc = "VLC";
              orphan = true;
            }
          ];
          reveal = [
            {
              run = "thunar \"$(dirname \"$1\")\"";
              desc = "Reveal";
              orphan = true;
              for = "linux";
            }
            {
              run = "open -R \"$1\"";
              desc = "Reveal";
              orphan = true;
              for = "macos";
            }
            {
              run = "explorer /select;\"%1\"";
              orphan = true;
              desc = "Reveal";
              for = "windows";
            }
          ];
          preview = {
            image_delay = 0;
          };
          open = {
            rules = [
              # Folder
              {
                name = "*/";
                use = [
                  "edit"
                  "open"
                  "reveal"
                ];
              }
              # Text
              {
                mime = "text/*";
                use = [
                  "edit"
                  "reveal"
                ];
              }
              # Image
              {
                mime = "image/*";
                use = [
                  "open"
                  "reveal"
                ];
              }
              # Media
              {
                mime = "{audio,video}/*";
                use = [
                  "play"
                  "reveal"
                ];
              }
              # Archive
              {
                mime = "application/{,g}zip";
                use = [
                  "extract"
                  "reveal"
                ];
              }
              {
                mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
                use = [
                  "extract"
                  "reveal"
                ];
              }
              # JSON
              {
                mime = "application/{json,x-ndjson}";
                use = [
                  "edit"
                  "reveal"
                ];
              }
              {
                mime = "*/javascript";
                use = [
                  "edit"
                  "reveal"
                ];
              }
              # Empty file
              {
                mime = "inode/x-empty";
                use = [
                  "edit"
                  "reveal"
                ];
              }
              # Fallback
              {
                name = "*";
                use = [
                  "edit"
                  "open"
                  "reveal"
                ];
              }
            ];
          };
        };
      };
      zsh.initContent = lib.mkOrder 1000 /* bash */ ''
        # use this cmd to open yazi and cd into whatever directory it is in when it exits
        # taken from https://yazi-rs.github.io/docs/quick-start/
        if command -v yazi &>/dev/null; then
        ycd() {
        local tmp
        tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

        yazi "$@" --cwd-file="$tmp"

        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd" || return 1
        fi

        rm -f -- "$tmp"
        }
        fi
      '';
    };
  };
}
