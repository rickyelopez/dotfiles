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
    ../../../home
    ../../../platforms/linux/home
    ../../optional/gtk.nix
    ../../optional/hyprland.nix
    ../../optional/qt.nix
    ../../optional/rofi.nix
    ../../optional/sops.nix
  ];
}

