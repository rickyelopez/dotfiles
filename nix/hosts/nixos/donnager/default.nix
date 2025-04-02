{ inputs, host, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.lix-module.nixosModules.default

    ../../common/core
    ./configuration.nix
  ];

  hostSpec = {
    username = "ricclopez";
    hostname = host;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
