{ inputs, pkgs, ... }:
{
  imports = [
    inputs.jetpack.nixosModules.default
  ];

  hardware = {
    nvidia-container-toolkit.enable = true;

    nvidia-jetpack = {
      enable = true;
      som = "orin-nx";
      carrierBoard = "devkit";
      super = true;
    };

    graphics.enable = true;
  };

  services.nvpmodel.configFile = "${pkgs.nvidia-jetpack.l4t-nvpmodel}/etc/nvpmodel/nvpmodel_p3767_0001_super.conf";
}
