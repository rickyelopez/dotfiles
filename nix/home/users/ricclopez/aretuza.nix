{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      calibre
      discord
      ferdium
      mesa-demos
    ];
  };
  imports = [
    ../../../home
    ../../../platforms/linux/home
    ../../optional/gaming.nix
    ../../optional/gtk.nix
    ../../optional/hyprland.nix
    ../../optional/qt.nix
    ../../optional/rofi.nix
    ../../optional/sops.nix
  ];
}

