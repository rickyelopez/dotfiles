{ pkgs, config, hostSpec, lib, ... }:
let
  cfg = config.my.rofi;
  home = hostSpec.home;
in
{
  options.my.rofi = {
    enable = lib.mkEnableOption "home rofi module.";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        rofi
      ];

      file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
        ".config/rofi".source = mkLink "${home}/dotfiles/.config/rofi";
      };
    };
  };
}
