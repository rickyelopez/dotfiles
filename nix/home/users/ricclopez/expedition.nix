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
    ../../common/optional/gtk.nix
    ../../common/optional/hyprland.nix
    ../../common/optional/qt.nix
    ../../common/optional/rofi.nix
    ../../common/optional/sops.nix
  ];
}

