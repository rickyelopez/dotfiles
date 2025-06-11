{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      bazelisk
      protobuf
    ];

    shellAliases = {
      bazel = "bazelisk"; # FIXME: move bazelisk somewhere common and take this alias with it
    };
  };


  imports = [
    ../../../home
    ../../../platforms/linux/home
  ];
}

