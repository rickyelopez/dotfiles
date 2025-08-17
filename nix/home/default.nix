{ pkgs, config, hostSpec, ... }:
let
  user = hostSpec.username;
  home = hostSpec.home;
in
{
  imports = [
    ./users/${user}/${hostSpec.hostname}.nix
    ./common/station.nix
  ];

  home = {
    stateVersion = "24.05"; # don't change

    username = user;
    homeDirectory = home;

    packages = with pkgs; [
      bat
      bash
      bitwise
      fd
      fzf
      fx
      git
      htop
      jq
      lsof
      nixd
      ripgrep
      rsync
      tmux
      unzip
      watch
      wget
      yq
    ];

    file = config.lib.file.mkDotfilesSymlinks [
      ".config/tmux"
      ".config/uncrustify.cfg"
    ];
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    fzf.enable = true;
  };

  my = {
    fx.enable = true;
    git.enable = true;
    yazi.enable = true;
  };
}
