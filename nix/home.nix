{ pkgs, home, user, config, lib, ... }:
{
  home = {
    stateVersion = "24.05"; # don't change

    username = user;
    homeDirectory = home;

    packages = with pkgs; [
      bat
      bear
      cmake
      delta
      fd
      ffmpeg
      fzf
      fx
      git
      git-lfs
      htop
      just
      jq
      lazygit
      gcc
      gnumake
      lsof
      meson
      mutagen
      neovim-remote
      nerd-fonts.blex-mono
      nerd-fonts.noto
      ninja
      obsidian
      pre-commit
      ra-multiplex
      ripgrep
      rsync
      socat
      sshpass
      tio
      tmux
      unzip
      uv
      vim
      watch
      wget
      yq
    ]
    # packages for linux only
    ++ lib.lists.optionals pkgs.stdenv.isLinux [
      ouch
      rustup
      trash-cli
    ];

    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/ghostty".source = mkLink "${home}/dotfiles/.config/ghostty";
      ".config/lazygit/config.yml".source = mkLink "${home}/dotfiles/.config/lazygit/config.yml";
      ".config/stylua".source = mkLink "${home}/dotfiles/.config/stylua";
      ".config/tmux".source = mkLink "${home}/dotfiles/.config/tmux";
      ".config/clangd/config.yaml".source = mkLink "${home}/dotfiles/.config/clangd/config.yaml";
      ".p10k.zsh".source = mkLink "${home}/dotfiles/.p10k.zsh";
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

    direnv.enable = true;

    fzf.enable = true;

    gh = {
      enable = true;
      extensions = [
        pkgs.gh-dash
      ];
    };

    kitty = {
      enable = true;
      font = {
        name = "Blex Mono Nerd Font Mono";
        size = 11.0;
      };
    };

    pyenv.enable = true;
  };

  services = {
    lorri.enable = true;
  };

  imports = [
    ./modules/alacritty.nix
    ./modules/fx.nix
    ./modules/nvim.nix
    # ./modules/wezterm.nix
    ./modules/yazi.nix
    ./modules/zsh.nix
  ];
}
