{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      protobuf
    ];
  };


  imports = [
    ../../../home
    ../../../platforms/linux/home
  ];

  my = {
    bazel.enable = true;
    docker.enable = true;
  };
}

