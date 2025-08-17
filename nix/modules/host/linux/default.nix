{ isDarwin, lib, ... }:
{
  imports = lib.optionals (!isDarwin) (lib.custom.scanPaths ./.);
}
