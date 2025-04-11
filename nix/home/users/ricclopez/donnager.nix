{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      gcc
    ];
  };
  imports = [
    ../../../home
    ../../optional/sops.nix
    ../../../platforms/linux/home
  ];
}
