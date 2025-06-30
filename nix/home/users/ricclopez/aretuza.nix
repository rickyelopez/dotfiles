{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      calibre
      discord
      ferdium
      mesa-demos
      rivalcfg
    ];
  };
  imports = [
    ../../../home
    ../../../platforms/linux/home
    ../../common/optional/gaming.nix
    ../../common/optional/gtk.nix
    ../../common/optional/hyprland.nix
    ../../common/optional/qt.nix
    ../../common/optional/rofi.nix
    ../../common/optional/ssh.nix
    ../../common/optional/sops.nix
  ];
}

