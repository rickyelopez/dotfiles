{ config, lib, ... }:
let
  cfg = config.my.nvidia;
in
{
  options.my.nvidia = {
    enable = lib.mkEnableOption "host nvidia module.";
    runtime.enable = lib.mkEnableOption "nvidia container runtime.";
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      nvidia = {
        modesetting.enable = true;
        powerManagement = {
          enable = true;
          finegrained = false;
        };
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      nvidia-container-toolkit.enable = cfg.runtime.enable;
    };

    virtualisation.docker.daemon.settings.features.cdi = cfg.runtime.enable;

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
