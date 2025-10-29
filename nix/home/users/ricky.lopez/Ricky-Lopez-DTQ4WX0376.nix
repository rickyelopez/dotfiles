{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      ghostty-bin
      k9s
      util-linux
    ];
    file = {
      ".hammerspoon/Spoons/SpoonInstall.spoon".source = pkgs.fetchzip {
        url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip";
        hash = "sha256-3f0d4znNuwZPyqKHbZZDlZ3gsuaiobhHPsefGIcpCSE=";
      };
      ".hammerspoon/Spoons/Swipe.spoon".source = pkgs.fetchzip {
        url = "https://github.com/mogenson/Swipe.spoon/archive/c56520507d98e663ae0e1228e41cac690557d4aa.zip";
        hash = "sha256-G0kuCrG6lz4R+LdAqNWiMXneF09pLI+xKCiagryBb5k=";
      };
    }
    // config.lib.file.mkDotfilesSymlinks [
      ".hammerspoon/init.lua"
      ".hammerspoon/.luarc.json"
      ".hammerspoon/modules"
    ];
  };

  programs = {
    git = {
      includes = [
        {
          path = "~/dotfiles_priv/.config/git/config";
        }
      ];
    };
  };

  my = {
    bazel.enable = true;
    docker.enable = true;
    remote-open.enable = true;
    sops.enable = true;
  };
}
