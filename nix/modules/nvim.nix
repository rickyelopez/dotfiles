{ inputs, pkgs, config, hostSpec, ... }:
let
  home = hostSpec.home;
in
{
  home.file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
    ".config/nvim".source = mkLink "${home}/dotfiles/.config/nvim";
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly.packages.${pkgs.system}.default;
    defaultEditor = true;
  };
}
