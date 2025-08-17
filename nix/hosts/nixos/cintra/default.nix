{ inputs, host, ... }: {
  imports = [
    inputs.lix-module.nixosModules.default

    ./configuration.nix
    ./hardware-configuration.nix

    ../../common/optional/ssh.nix
  ];

  hostSpec = {
    username = "nonroot";
    hostname = host;
    domain = "forestroot.elexpedition.com";
    isServer = true;
    isHeadless = true;
  };

  my.docker.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}

