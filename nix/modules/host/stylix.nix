{
  isDarwin,
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.stylix;
  module = if isDarwin then inputs.stylix.darwinModules.stylix else inputs.stylix.nixosModules.stylix;
in
{
  imports = [ module ];

  options.my.stylix = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "host stylix module.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-moon.yaml";

      fonts = {
        serif = {
          package = pkgs.nerd-fonts.noto;
          name = "Noto Serif";
        };

        sansSerif = {
          package = pkgs.nerd-fonts.noto;
          name = "Noto Sans";
        };

        monospace = {
          package = pkgs.nerd-fonts.blex-mono;
          name = "BlexMono Nerd Font Mono";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };

      };
    }
    // (
      if (!isDarwin) then
        {
          cursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Ice";
            size = 24;
          };
          icons = {
            enable = true;
            package = pkgs.papirus-icon-theme;
            dark = "Papirus-Dark";
          };
        }
      else
        { }
    );

  };
}
