{ inputs, outputs, host, ... }: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.sops-nix.darwinModules.sops

    ../darwin/${host}
  ];

  nixpkgs.overlays = [
    outputs.overlays.default
  ];
}
