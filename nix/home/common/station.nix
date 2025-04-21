{ pkgs, config, hostSpec, ... }:
let
  home = hostSpec.home;
in
{
  home = {
    packages = with pkgs; [
      bear
      bitwarden-cli
      cmake
      delta
      ffmpeg
      fx
      git-lfs
      just
      jqp
      lazygit
      gcc
      gnumake
      meson
      mutagen
      neovim-remote
      nerd-fonts.blex-mono
      nerd-fonts.noto
      ninja
      obsidian
      pre-commit
      ra-multiplex
      python313
      socat
      sshpass
      tio
      uncrustify
      uv
    ];

    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/ghostty".source = mkLink "${home}/dotfiles/.config/ghostty";
      ".config/lazygit/config.yml".source = mkLink "${home}/dotfiles/.config/lazygit/config.yml";
      ".config/stylua".source = mkLink "${home}/dotfiles/.config/stylua";
      ".config/clangd/config.yaml".source = mkLink "${home}/dotfiles/.config/clangd/config.yaml";
      ".p10k.zsh".source = mkLink "${home}/dotfiles/.p10k.zsh";
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    autojump.enable = true;

    direnv.enable = true;

    # kitty = {
    #   enable = true;
    #   font = {
    #     name = "Blex Mono Nerd Font Mono";
    #     size = 11.0;
    #   };
    # };

    pyenv.enable = true;
  };

  imports = [
    # ../optional/alacritty.nix
    ../optional/nvim.nix
    # ../optional/wezterm.nix
    ../optional/zsh.nix
  ];
}

