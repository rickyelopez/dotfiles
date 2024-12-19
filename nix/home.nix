{ pkgs, home, user, config, lib, ... }:
let
  inherit (pkgs) stdenv;
in
{
  home = {
    # don't change
    stateVersion = "24.05";

    username = user;
    homeDirectory = home;

    packages = with pkgs; [
      bat
      delta
      direnv
      fd
      ffmpeg
      fzf
      git-lfs
      htop
      just
      jq
      lazygit
      mutagen
      # portaudio
      ripgrep
      rsync
      socat
      sshpass
      tmux
      watch
      wget
      yazi
      yq
    ]
    # packages for mac only
    ++ lib.lists.optionals stdenv.isDarwin [
      k9s
      bazelisk
      obsidian
      util-linux
    ]
    # packages for linux only
    ++ lib.lists.optionals stdenv.isLinux [
      vlc
      (nerdfonts.override { fonts = [ "IBMPlexMono" "Noto" ]; })
    ];

    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/yazi/keymap.toml".source = mkLink "${home}/dotfiles/.config/yazi/keymap.toml";
      ".config/yazi/package.toml".source = mkLink "${home}/dotfiles/.config/yazi/package.toml";
      ".config/yazi/yazi.toml".source = mkLink "${home}/dotfiles/.config/yazi/yazi.toml";
    }
    // lib.attrsets.optionalAttrs stdenv.isDarwin {
      ".hammerspoon/init.lua".source = mkLink "${home}/dotfiles/.hammerspoon/init.lua";
      ".hammerspoon/.luarc.json".source = mkLink "${home}/dotfiles/.hammerspoon/.luarc.json";
      ".hammerspoon/modules".source = mkLink "${home}/dotfiles/.hammerspoon/modules";
      ".hammerspoon/Spoons/SpoonInstall.spoon" = {
        source = pkgs.fetchzip {
          url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip";
          hash = "sha256-3f0d4znNuwZPyqKHbZZDlZ3gsuaiobhHPsefGIcpCSE=";
        };
      };
      ".hammerspoon/Spoons/Swipe.spoon" = {
        source = pkgs.fetchzip {
          url = "https://github.com/mogenson/Swipe.spoon/archive/c56520507d98e663ae0e1228e41cac690557d4aa.zip";
          hash = "";
        };
      };

      ".config/aerospace".source = mkLink "${home}/dotfiles/.config/aerospace/";
    };
  };

  fonts.fontconfig.enable = true;

  xdg = {
    configFile = {
      # I think this is necessary because the file must exist in order to enable
      # experimental features before this flake can build
      "nix/nix.conf".enable = false;
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    autojump.enable = true;
    gh = {
      enable = true;
      extensions = [
        pkgs.gh-dash
      ];
    };
    # kitty = {
    #     enable = true;
    #     font = {
    #         name = "Blex Mono Nerd Font Mono";
    #         size = 11.0;
    #     };
    # };
  };

  imports = [
    ./modules/wezterm.nix
    # ./modules/zsh.nix
  ];
}
