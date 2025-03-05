{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      gcc
    ];
  };
  imports = [
    ../../home.nix
    ../../platforms/linux/home.nix
  ];
}
