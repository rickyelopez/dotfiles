{ lib, config, isStandaloneHm, ... }:
{
  imports = [
    ../../../host-spec.nix
    ../users
  ] ++ lib.optionals (!isStandaloneHm) [ ./full.nix ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ ] ++ lib.optionals (config.hostSpec.isDarwin) [
      # issues building bitwarden-cli on darwin-aarch64
      # https://github.com/NixOS/nixpkgs/issues/339576
      (final: prev: {
        bitwarden-cli = prev.bitwarden-cli.overrideAttrs (
          oldAttrs: {
            nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ prev.llvmPackages_18.stdenv.cc ];
            stdenv = prev.llvmPackages_18.stdenv;
          }
        );
      })
    ];
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # Disable auto-optimise-store because of this issue:
      #   https://github.com/NixOS/nix/issues/7273
      # "error: cannot link '/nix/store/.tmp-link-xxxxx-xxxxx' to '/nix/store/.links/xxxx': File exists"
      auto-optimise-store = false;
      warn-dirty = false;
    };
  };

  time.timeZone = "America/Los_Angeles";
}
