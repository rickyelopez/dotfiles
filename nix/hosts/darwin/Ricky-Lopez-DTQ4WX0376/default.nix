{ inputs, host, ... }: {
  imports = [
    inputs.home-manager.darwinModules.home-manager

    ../../common/core
    ./configuration.nix
  ];

  hostSpec = {
    username = "ricky.lopez";
    hostname = host;
    isDarwin = true;
    isWork = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 4;
}
