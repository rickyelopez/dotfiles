{ pkgs, hostSpec, ... }:
let
  user = hostSpec.username;
in
{
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
}
