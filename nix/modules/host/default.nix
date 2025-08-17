{ lib, ... }:
let
  hostFiles = lib.custom.scanPaths ./.;
in
{
  imports = [] ++ hostFiles;
}
