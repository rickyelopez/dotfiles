{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.wezterm;
in
{
  options.my.wezterm = {
    enable = lib.mkEnableOption "home wezterm module.";
  };

  config = lib.mkIf cfg.enable {
    # disable automatic generation of the wezterm.lua file by home manager. Manually link the file instead (see below)
    xdg.configFile."wezterm/wezterm.lua".enable = false;

    home = {
      file = config.lib.file.mkDotfilesSymlink [
        ".config/wezterm/wezterm.lua"
      ];
      packages = with pkgs; [ wezterm.terminfo ];
    };

    programs.wezterm.enable = true;
  };
}
