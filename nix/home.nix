{ pkgs, home, user, ... }: {
  home = {
    # don't change
    stateVersion = "24.05";

    username = user;
    homeDirectory = home;

    packages = with pkgs; [
      bat
      # bazelisk
      delta
      fd
      ffmpeg
      fzf
      git-lfs
      htop
      jq
      # k9s
      lazygit
      mutagen
      # obsidian
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
      (nerdfonts.override { fonts = [ "IBMPlexMono" "Noto" ]; })
    ];
  };

  fonts.fontconfig.enable = true;

  # I think this is necessary because the file must exist in order to enable
  # experimental features before this flake can build
  xdg.configFile."nix/nix.conf".enable = false;

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
    # zsh.enable = true;
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
  ];
}
