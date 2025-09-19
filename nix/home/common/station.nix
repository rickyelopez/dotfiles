{ pkgs, config, hostSpec, lib, ... }:
{
  config = lib.mkIf (!hostSpec.isServer) {
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
        lld
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
        sqlitebrowser
        tio
        uncrustify
        uv
      ];

      file = config.lib.file.mkDotfilesSymlinks [
        ".config/ghostty"
        ".config/lazygit/config.yml"
        ".config/stylua"
        ".config/clangd/config.yaml"
        ".p10k.zsh"
      ];
    };

    fonts.fontconfig.enable = true;

    programs = {
      autojump.enable = true;
      direnv.enable = true;
      pyenv.enable = true;
    };

    my = {
      nvim.enable = true;
      zsh.enable = true;
    };
  };
}

