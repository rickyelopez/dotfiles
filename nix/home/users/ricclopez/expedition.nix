{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      brightnessctl
      calibre
      ferdium
      mesa-demos
    ];
  };

  imports = [
    ../../../platforms/linux/home
  ];

  my = {
    docker.enable = true;
    gtk.enable = true;
    hyprland.enable = true;
    qt.enable = true;
    rofi.enable = true;
    sops.enable = true;
  };
}

