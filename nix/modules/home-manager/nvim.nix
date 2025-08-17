{ inputs, pkgs, config, hostSpec, lib, ... }:
let
  cfg = config.my.nvim;
  home = hostSpec.home;
in
{
  options.my.nvim = {
    enable = lib.mkEnableOption "home nvim module.";
  };

  config = lib.mkIf cfg.enable {
    home.file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/nvim".source = mkLink "${home}/dotfiles/.config/nvim";
    };

    programs.neovim = {
      enable = true;
      package = inputs.neovim-nightly.packages.${pkgs.system}.default;
      defaultEditor = true;
    };
  };
}
