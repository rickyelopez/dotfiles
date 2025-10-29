{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      protobuf
    ];
  };

  imports = [
    ../../../platforms/linux/home
  ];

  my = {
    bazel.enable = true;
    docker.enable = true;
    remote-open.client.enable = true;
  };
}
