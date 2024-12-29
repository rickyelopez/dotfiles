{ pkgs, inputs, home, user, config, lib, ... }:
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
      cmake
      delta
      direnv
      fd
      ffmpeg
      fzf
      ghostty
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
    # packages for mac only
    ++ lib.lists.optionals stdenv.isDarwin [
      k9s
      bazelisk
      util-linux
    ]
    # packages for linux only
    ++ lib.lists.optionals stdenv.isLinux [
      rustup
      nerd-fonts.blex-mono
      nerd-fonts.noto
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
    neovim = {
      enable = true;
      package = inputs.neovim-nightly.packages.${pkgs.system}.default;
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
    # ./modules/wezterm.nix
    ./modules/zsh.nix
  ];
}
