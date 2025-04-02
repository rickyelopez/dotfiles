{ pkgs, home, config, ... }:
{
  home = {
    packages = with pkgs; [
      k9s
      bazelisk
      util-linux
    ];
    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".hammerspoon/init.lua".source = mkLink "${home}/dotfiles/.hammerspoon/init.lua";
      ".hammerspoon/.luarc.json".source = mkLink "${home}/dotfiles/.hammerspoon/.luarc.json";
      ".hammerspoon/modules".source = mkLink "${home}/dotfiles/.hammerspoon/modules";
      ".hammerspoon/Spoons/SpoonInstall.spoon".source = pkgs.fetchzip {
        url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip";
        hash = "sha256-3f0d4znNuwZPyqKHbZZDlZ3gsuaiobhHPsefGIcpCSE=";
      };
      ".hammerspoon/Spoons/Swipe.spoon".source = pkgs.fetchzip {
        url = "https://github.com/mogenson/Swipe.spoon/archive/c56520507d98e663ae0e1228e41cac690557d4aa.zip";
        hash = "sha256-G0kuCrG6lz4R+LdAqNWiMXneF09pLI+xKCiagryBb5k=";
      };
    };
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

  imports = [
    ../../home.nix
  ];
}

