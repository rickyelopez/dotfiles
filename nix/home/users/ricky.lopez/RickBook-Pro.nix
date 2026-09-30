{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      bluesnooze
      caffeine
      ccache
      gdal
      iproute2mac
      k9s
      karabiner-elements
      ksnip-bin
      libgit2
      notunes
      opencv
      openssl
      portaudio
      readline
      sqlite
      tcl
      util-linux
      vlc-bin
      wireshark
      xz
      zlib
    ];

    file = config.lib.file.mkDotfilesSymlinks [
      ".config/karabiner/karabiner.json"
    ];
  };

  programs = {
    git = {
      includes = [
        {
          path = "~/dotfiles_priv/.config/git/config";
        }
      ];
    };
  };

  my = {
    bazel.enable = true;
    docker.enable = true;
    ghostty.enable = true;
    remote-open.enable = true;
    sops.enable = true;
    stylix.enable = true;
    vicinae.enable = true;
    work = {
      enable = true;
      secrets.enable = true;
    };
    zsh.zprof = false;
  };
}
