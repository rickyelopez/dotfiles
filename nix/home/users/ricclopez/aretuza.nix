{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      calibre
      ferdium
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

