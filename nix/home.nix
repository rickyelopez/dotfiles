{ pkgs, home, ... }: {
  home = {
    # don't change
    stateVersion = "24.05";

    username = "ricky.lopez";
    homeDirectory = home;

    packages = with pkgs; [
      bat
      bazelisk
      delta
      fd
      ffmpeg
      fzf
      git-lfs
      htop
      jq
      k9s
      lazygit
      mutagen
      obsidian
      # portaudio
      ripgrep
      rsync
      socat
      sshpass
      tmux
      util-linux
      watch
      wget
      yazi
      yq
    ];
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    autojump.enable = true;
  };

  imports = [
    ./modules/wezterm.nix
  ];
}
