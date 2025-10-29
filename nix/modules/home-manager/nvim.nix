{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.nvim;
in
{
  options.my.nvim = {
    enable = lib.mkEnableOption "home nvim module.";
  };

  config = lib.mkIf cfg.enable {
    home.file = config.lib.file.mkDotfilesSymlinks [
      ".config/nvim"
    ];

    programs.neovim = {
      enable = true;
      package = inputs.neovim-nightly.packages.${pkgs.system}.default;
      defaultEditor = true;
    };
  };
}
