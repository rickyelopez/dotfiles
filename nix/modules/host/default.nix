{ lib, ... }:
let
  hostFiles = lib.custom.scanPaths ../host;
in
{
  imports = [] ++ hostFiles;
}
