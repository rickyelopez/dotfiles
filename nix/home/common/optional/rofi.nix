{ pkgs, config, hostSpec, ... }:
let
  home = hostSpec.home;
in
{
  home = {
    packages = with pkgs; [
      rofi
    ];
    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/rofi".source = mkLink "${home}/dotfiles/.config/rofi";
    };

  };
}
