{ config, hostSpec, ... }:
let
  home = hostSpec.home;
in
{
  home = {
    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/Kvantum".source = mkLink "${home}/dotfiles/.config/Kvantum";
      ".config/qt5ct".source = mkLink "${home}/dotfiles/.config/qt5ct";
      ".config/qt6ct".source = mkLink "${home}/dotfiles/.config/qt6ct";
    };
  };
}
