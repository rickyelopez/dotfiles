{ pkgs }:
let
  bin = pkgs.lib.getBin pkgs.llvmPackages.bintools;
in
pkgs.symlinkJoin {
  name = "ld-only";
  paths = [ bin ];
  postBuild = ''
    # keep just ld and ld.lld
    cd "$out/bin"
    for f in *; do
      case "$f" in
        ld|ld.lld) ;;
        *) rm -f "$f" ;;
      esac
    done
  '';
}
