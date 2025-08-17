{ config, hostSpec, lib, ... }:
let
  cfg = config.my.qt;
  home = hostSpec.home;
in
{
  options.my.qt = {
    enable = lib.mkEnableOption "home qt module.";
  };

  config = lib.mkIf cfg.enable {
    home = {
      file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
        ".config/Kvantum".source = mkLink "${home}/dotfiles/.config/Kvantum";
        ".config/qt5ct".source = mkLink "${home}/dotfiles/.config/qt5ct";
        ".config/qt6ct".source = mkLink "${home}/dotfiles/.config/qt6ct";
      };
    };
  };
}
