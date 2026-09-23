{
  pkgs,
  config,
  hostSpec,
  ...
}:
{
  imports =
    [ ]
    ++ (if (!hostSpec.isDarwin) then [ ../../linux/home ] else [ ])
    ++ (if (!hostSpec.isServer) then [ ./station.nix ] else [ ]);

  home = {
    packages = with pkgs; [
      bash
      bat
      bear
      bitwarden-cli
      bitwise
      cmake
      fd
      ffmpeg
      fx
      fzf
      gcc
      git-lfs
      gnumake
      htop
      jq
      jqp
      just
      lazygit
      lld-only
      lsof
      lspmux
      meson
      mutagen
      ncdu
      neovim-remote
      nerd-fonts.blex-mono
      nerd-fonts.noto
      ninja
      nixd
      nixfmt
      python314
      ripgrep
      rsync
      socat
      sshpass
      tcpdump
      tio
      uncrustify
      unzip
      uv
      watch
      wget
      yq
    ];

    file = config.lib.file.mkDotfilesSymlinks [
      ".config/clangd/config.yaml"
      ".config/lazygit/config.yml"
      ".config/stylua"
      ".config/tuicr/config.toml"
      ".config/uncrustify.cfg"
    ];
  };

  fonts.fontconfig.enable = true;

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    fzf.enable = true;
  };

  my = {
    autojump.enable = true;
    direnv.enable = true;
    fx.enable = true;
    git.enable = true;
    nvim.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    zsh.enable = true;
  };
}
