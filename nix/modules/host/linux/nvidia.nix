{ config, lib, ... }:
let
  cfg = config.my.nvidia;
in
{
  options.my.nvidia = {
    enable = lib.mkEnableOption "host nvidia module.";
  };

  config = lib.mkIf cfg.enable {
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
