{ lib, ... }:
{
  # use path relative to the nix root
  relativeToRoot = path: lib.path.append ../. path;

  relativeToRepoRoot = path: lib.path.append ../../. path;

  # get all .nix files in the given dir
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: typ:
          (typ == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include only .nix files
          )
        ) (builtins.readDir path)
      )
    );
}
