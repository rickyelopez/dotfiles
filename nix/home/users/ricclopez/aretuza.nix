{ pkgs, ... }:
{
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
    ../../../platforms/linux/home
    ../../common/optional/gaming.nix
  ];

  my = {
    docker.enable = true;
    gtk.enable = true;
    hyprland.enable = true;
    qt.enable = true;
    rofi.enable = true;
    sops.enable = true;
    ssh.enable = true;
  };
}
