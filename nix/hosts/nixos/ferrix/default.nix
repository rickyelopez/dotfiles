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
    lab.enable = true;
    ssh.enable = true;
    virtualisation.docker.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
