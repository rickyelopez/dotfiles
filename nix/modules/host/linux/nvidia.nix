{ config, lib, ... }:
let
  cfg = config.my.nvidia;
in
{
  options.my.nvidia = {
    enable = lib.mkEnableOption "host nvidia module.";
    cuda = lib.mkEnableOption "cuda support.";
    open = lib.mkOption {
      type = lib.types.bool;
      description = "open source driver.";
      default = true;
    };
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
        open = cfg.open;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      nvidia-container-toolkit.enable = cfg.runtime.enable;
    };

    virtualisation.docker.daemon.settings.features.cdi = cfg.runtime.enable;

    services.xserver.videoDrivers = [ "nvidia" ];

    nixpkgs.config.cudaSupport = cfg.cuda;
  };
}
