{ pkgs, home, user, config, ... }:
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
      # general
      ".config/yazi".source = mkLink "${home}/dotfiles/.config/yazi/";

      # hammerspoon
      ".hammerspoon/init.lua".source = mkLink "${home}/dotfiles/.hammerspoon/init.lua";
      ".hammerspoon/.luarc.json".source = mkLink "${home}/dotfiles/.hammerspoon/.luarc.json";
      ".hammerspoon/modules".source = mkLink "${home}/dotfiles/.hammerspoon/modules";
      ".hammerspoon/Spoons/SpoonInstall.spoon".source = pkgs.fetchzip {
        url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip";
        hash = "sha256-3f0d4znNuwZPyqKHbZZDlZ3gsuaiobhHPsefGIcpCSE=";
      };

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
