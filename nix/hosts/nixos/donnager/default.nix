{ inputs, host, ... }:
{
  imports = [
    ./configuration.nix
  ];

  hostSpec = {
    username = "ricclopez";
    hostname = host;
    domain = "forestroot.elexpedition.com";
    isHeadless = true;
  };

  my = {
    virtualisation.docker.enable = true;
    sops.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
