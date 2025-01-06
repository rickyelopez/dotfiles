{ pkgs, inputs, home, user, config, lib, ... }:
{
  home = {
    stateVersion = "24.05"; # don't change

    username = user;
    homeDirectory = home;

    packages = with pkgs; [
      bat
      cmake
      delta
      direnv
      fd
      ffmpeg
      fzf
      git
      git-lfs
      htop
      just
      jq
      lazygit
      gcc
      gnumake
      lsof
      mutagen
      nerd-fonts.blex-mono
      nerd-fonts.noto
      obsidian
      ripgrep
      rsync
      socat
      sshpass
      tmux
      unzip
      vim
      watch
      wget
      yazi
      yq
    ]
    # packages for linux only
    ++ lib.lists.optionals pkgs.stdenv.isLinux [
      rustup
    ];

    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".antidote".source = mkLink "${home}/dotfiles/.antidote";
      ".config/ghostty".source = mkLink "${home}/dotfiles/.config/ghostty";
      ".config/lazygit/config.yml".source = mkLink "${home}/dotfiles/.config/lazygit/config.yml";
      ".config/nvim".source = mkLink "${home}/dotfiles/.config/nvim";
      ".config/stylua".source = mkLink "${home}/dotfiles/.config/stylua";
      ".config/tmux".source = mkLink "${home}/dotfiles/.config/tmux";
      ".config/yazi/keymap.toml".source = mkLink "${home}/dotfiles/.config/yazi/keymap.toml";
      ".config/yazi/package.toml".source = mkLink "${home}/dotfiles/.config/yazi/package.toml";
      ".config/yazi/yazi.toml".source = mkLink "${home}/dotfiles/.config/yazi/yazi.toml";
      ".p10k.zsh".source = mkLink "${home}/dotfiles/.p10k.zsh";
      ".zsh_plugins.txt".source = mkLink "${home}/dotfiles/.zsh_plugins.txt";
      ".zshrc".source = mkLink "${home}/dotfiles/.zshrc";
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
    neovim = {
      enable = true;
      package = inputs.neovim-nightly.packages.${pkgs.system}.default;
      defaultEditor = true;
    };
    kitty = {
      enable = true;
      font = {
        name = "Blex Mono Nerd Font Mono";
        size = 11.0;
      };
    };
  };

  imports = [
    ./modules/alacritty.nix
    ./modules/wezterm.nix
    ./modules/zsh.nix
  ];
}
