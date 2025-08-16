{ lib, ... }:
{
  # use path relative to the nix root
  relativeToRoot = lib.path.append ../.;

  # get all .nix files in the given dir
  scanPaths = path: builtins.map (f: (path + "/${f}")) (
    builtins.attrNames (
      lib.attrsets.filterAttrs
        (
          path: typ:
            (typ == "directory") # include directories
            || (
              (path != "default.nix") # ignore default.nix
              && (lib.strings.hasSuffix ".nix" path) # include .nix files
            )
        )
        (builtins.readDir path)
    )
  );
}
