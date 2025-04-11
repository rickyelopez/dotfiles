{ ... }:
let
  additions =
    final: prev:
    (prev.lib.packagesFromDirectoryRecursive {
      callPackage = prev.lib.callPackageWith final;
      directory = ../pkgs/common;
    });

  modifications =
    final: prev: {
      fprintd = prev.fprintd.overrideAttrs (oldAddrs: rec {
        version = "1.94.4";
        src = prev.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "libfprint";
          repo = "fprintd";
          rev = "refs/tags/v${version}";
          hash = "sha256-B2g2d29jSER30OUqCkdk3+Hv5T3DA4SUKoyiqHb8FeU=";
        };
      });
    };

in
{
  default =
    final: prev:
    (additions final prev)
    // (modifications final prev);
}
