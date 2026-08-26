{
  inputs,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      protobuf
    ];
  };

  imports = [
    ../../../platforms/linux/home
    inputs.stylix.homeModules.stylix
  ];

  my = {
    bazel.enable = true;
    docker.enable = true;
    remote-open.client.enable = true;
    sops = {
      enable = true;
      addKeys = false;
    };
    stylix.enable = true;
    work = {
      enable = true;
      secrets.enable = true;
    };
  };
}
