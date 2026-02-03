{ inputs, host, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  hostSpec = {
    username = "nonroot";
    hostname = host;
    domain = "forestroot.elexpedition.com";
    isServer = true;
    isHeadless = true;
  };

  my = {
    virtualisation.docker.enable = true;
    ssh.enable = true;
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";
}
