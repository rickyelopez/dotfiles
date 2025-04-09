{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      bazelisk
      gcc
      nodePackages.npm
      protobuf
    ];
  };

  imports = [
    ../../home.nix
    ../../platforms/linux/home
  ];
}

