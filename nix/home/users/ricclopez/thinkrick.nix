{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      bazelisk
      protobuf
    ];
  };

  imports = [
    ../../../home
    ../../../platforms/linux/home
  ];
}

