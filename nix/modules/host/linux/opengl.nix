{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.my.opengl;
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.my.opengl = {
    enable = lib.mkEnableOption "host opengl module.";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      package = pkgs-unstable.mesa;
      enable32Bit = true;
      package32 = pkgs-unstable.pkgsi686Linux.mesa;
    };

    environment.systemPackages = with pkgs; [
      gpustat
    ];
  };
}
