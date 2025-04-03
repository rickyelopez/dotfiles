{ inputs, host, ... }: {
  imports = [
    inputs.lix-module.nixosModules.default
    inputs.madness.nixosModules.madness

    ../../common/core
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  hostSpec = {
    username = "ricclopez";
    hostname = host;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
