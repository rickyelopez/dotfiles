{ pkgs, home, user, ... }:
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
    ];
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
  };

  imports = [
    ./modules/wezterm.nix
    # ./modules/zsh.nix
  ];
}
