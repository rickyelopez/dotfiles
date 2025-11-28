{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      brightnessctl
      buck2
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
    rofi.enable = true;
    sops.enable = true;
    ssh.enable = true;
  };
}
