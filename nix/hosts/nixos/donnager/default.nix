{ inputs, host, ... }:
{
  imports = [
    inputs.lix-module.nixosModules.default

    ./configuration.nix

    ../../common/core
    ../../common/optional/docker.nix
    ../../common/optional/sops.nix
  ];

  hostSpec = {
    username = "ricclopez";
    hostname = host;
    domain = "forestroot.elexpedition.com";
    isHeadless = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
