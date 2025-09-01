{ ... }:
let
  additions =
    final: prev:
    (prev.lib.packagesFromDirectoryRecursive
      {
        callPackage = prev.lib.callPackageWith final;
        directory = ../pkgs/common;
      }
    );

  modifications =
    final: prev: {
      # set up lix
      inherit (final.lixPackageSets.stable)
        nixpkgs-review
        nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena;
      fprintd = prev.fprintd.overrideAttrs (oldAttrs: rec {
        version = "1.94.4";
        src = prev.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "libfprint";
          repo = "fprintd";
          rev = "refs/tags/v${version}";
          hash = "sha256-B2g2d29jSER30OUqCkdk3+Hv5T3DA4SUKoyiqHb8FeU=";
        };
      });
      yaziPlugins =
        let
          mkYaziPlugin = prev.yaziPlugins.mkYaziPlugin;
          callPackage = prev.lib.callPackageWith final;
        in
        prev.yaziPlugins //
        (builtins.mapAttrs
          (name: _: callPackage ../pkgs/yaziPlugins/${name} { inherit mkYaziPlugin; })
          (builtins.readDir ../pkgs/yaziPlugins)
        );
    };
in
{
  default =
    final: prev:
    (additions final prev)
    // (modifications final prev);
}
