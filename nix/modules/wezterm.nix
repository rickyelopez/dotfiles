{ pkgs, config, hostSpec, ... }:
let
  home = hostSpec.home;
in
{
  home = {
    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/wezterm/wezterm.lua".source = mkLink "${home}/dotfiles/.config/wezterm/wezterm.lua";
    };
    packages = with pkgs; [ wezterm.terminfo ];
  };

  # disable automatic generation of the wezterm.lua file by home manager. Manually link the file instead (see above)
  xdg.configFile."wezterm/wezterm.lua".enable = false;

  programs.wezterm.enable = true;
}
