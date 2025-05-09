{ inputs, pkgs, ... }:
let pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  hardware.graphics = {
    enable = true;
    package = pkgs-unstable.mesa.drivers;
    enable32Bit = true;
    package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
  };

  environment.systemPackages = with pkgs; [
    gpustat
  ];

}
