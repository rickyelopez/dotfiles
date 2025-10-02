{ hostSpec, lib, ... }:
{
  imports = lib.optionals hostSpec.isDarwin (lib.custom.scanPaths ./.);
}
