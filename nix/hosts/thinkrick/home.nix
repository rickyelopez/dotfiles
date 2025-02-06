{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      nodePackages.npm
    ];
  };

  imports = [
    ../../home.nix
  ];
}
