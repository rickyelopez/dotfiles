{ pkgs, lib, config, hostSpec, ... }:
let
  user = hostSpec.username;
  home = hostSpec.home;
in
{
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

    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/tmux".source = mkLink "${home}/dotfiles/.config/tmux";
      ".config/uncrustify.cfg".source = mkLink "${home}/dotfiles/.config/uncrustify.cfg";
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    fzf.enable = true;
  };

  imports = [
    ./common/optional/fx.nix
    ./common/optional/git.nix
    ./common/optional/yazi.nix
  ] ++ lib.optionals (!hostSpec.isServer) [ ./common/station.nix ];
}
