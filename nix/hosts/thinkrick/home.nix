{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      bazelisk
      nodePackages.npm
      protobuf
    ];
  };

  imports = [
    ../../home.nix
  ];
}
