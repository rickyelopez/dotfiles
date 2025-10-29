{
  pkgs,
  lib,
  config,
  hostSpec,
  ...
}:
let
  cfg = config.my.gtk;
  user = hostSpec.username;
in
{
  options.my.gtk = {
    enable = lib.mkEnableOption "home gtk module.";
  };

  config = lib.mkIf cfg.enable {
    home = {
      pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
    };
    gtk = {
      enable = true;
      cursorTheme = {
        name = "Bibata-Modern-Classic";
        size = 16;
      };
      # gtk2.configLocation = "";
      gtk3 = {
        bookmarks = [
          "file:///home/${user}/Nextcloud"
          "file:///home/${user}/Downloads"
        ];
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };
      iconTheme.name = "Tokyonight-Light";
      theme = {
        package = pkgs.tokyonight-gtk-theme;
        name = "Tokyonight-Dark";
      };
    };
  };
}
