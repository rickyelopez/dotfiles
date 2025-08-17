{ inputs, outputs, host, ... }: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.sops-nix.darwinModules.sops

    ../darwin/${host}
  ];

  nixpkgs.overlays = [
    # issues building bitwarden-cli on darwin-aarch64
    # https://github.com/NixOS/nixpkgs/issues/339576
    (final: prev: {
      bitwarden-cli = prev.bitwarden-cli.overrideAttrs (
        finalAttrs: oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ prev.llvmPackages_18.stdenv.cc ];
          stdenv = prev.llvmPackages_18.stdenv;
          meta.broken = false;
        }
      );
    })
    outputs.overlays.default
  ];
}
