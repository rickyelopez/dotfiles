{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      gcc
    ];
  };
  imports = [
    ../../home.nix
    ../../home/optional/sops.nix
    ../../platforms/linux/home.nix
  ];
}
