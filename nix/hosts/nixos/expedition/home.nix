{ pkgs, home, config, user, ... }:
{
  home = {
    packages = with pkgs; [
      brave
      calibre
      ferdium
      gcc
      ghostty
      rofi
      vlc
    ];

    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/Kvantum".source = mkLink "${home}/dotfiles/.config/Kvantum";
      ".config/qt5ct".source = mkLink "${home}/dotfiles/.config/qt5ct";
      ".config/qt6ct".source = mkLink "${home}/dotfiles/.config/qt6ct";
      ".config/rofi".source = mkLink "${home}/dotfiles/.config/rofi";
      ".config/uwsm".source = mkLink "${home}/dotfiles/.config/uwsm";
      ".config/xdg-desktop-portal".source = mkLink "${home}/dotfiles/.config/xdg-desktop-portal";
    };
    pointerCursor = {
      gtk.enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-qt;
      size = 24;
    };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Adwaita";
      size = 24;
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

  imports = [
    ../../home.nix
    ../../platforms/linux/home.nix
    ../../modules/hyprland.nix
  ];
}
