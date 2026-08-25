{ host, ... }:
{
  imports = [
    ./configuration.nix
  ];

  hostSpec = {
    username = "ricky.lopez";
    hostname = host;
    isDarwin = true;
    isWork = true;
  };

  my = {
    stylix.enable = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 4;
}
