{ inputs, ... }:
{
  imports = [
    inputs.jetpack.nixosModules.default
  ];

  hardware.nvidia-jetpack = {
    enable = true;
    som = "orin-nano";
    carrierBoard = "devkit";
  };

  hardware.graphics.enable = true;
}
