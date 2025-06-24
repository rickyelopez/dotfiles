{ inputs, host, ... }: {
  imports = [
    inputs.lix-module.nixosModules.default

    ./configuration.nix
    ./hardware-configuration.nix

    ../../common/core
    ../../common/optional/docker.nix
    ../../common/optional/ssh.nix
  ];

  hostSpec = {
    username = "nonroot";
    hostname = host;
    domain = "forestroot.elexpedition.com";
    isServer = true;
    isHeadless = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}

