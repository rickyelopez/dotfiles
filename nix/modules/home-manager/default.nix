{ lib, ... }:
let
  homeFiles = lib.custom.scanPaths ../home-manager; # path "." doesn't work for some reason
in
{
  imports = [] ++ homeFiles;
}
