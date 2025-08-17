{ config, pkgs, lib, hostSpec, ... }:
let
  cfg = config.my.wezterm;
  home = hostSpec.home;
in
{
  options.my.wezterm = {
    enable = lib.mkEnableOption "home wezterm module.";
  };

  config = lib.mkIf cfg.enable {
    # disable automatic generation of the wezterm.lua file by home manager. Manually link the file instead (see below)
    xdg.configFile."wezterm/wezterm.lua".enable = false;

    home = {
      file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
        ".config/wezterm/wezterm.lua".source = mkLink "${home}/dotfiles/.config/wezterm/wezterm.lua";
      };
      packages = with pkgs; [ wezterm.terminfo ];
    };

    programs.wezterm.enable = true;
  };
}
