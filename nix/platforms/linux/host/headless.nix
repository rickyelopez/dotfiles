{ config, lib, ... }:
{
  config = lib.mkIf config.hostSpec.isHeadless { };
}
