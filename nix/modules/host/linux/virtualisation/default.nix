{ config, lib, ... }:
let
  virt = config.my.virtualisation;
in
{
  imports = lib.custom.scanPaths ./.;

  config = {
    assertions = [
      {
        assertion = !(virt.docker.enable && virt.podman.enable);
        message = "Cannot enable podman and docker at the same time! Only one of `docker.enable` and `podman.enable` can be true at a time.";
      }
    ];
  };
}
