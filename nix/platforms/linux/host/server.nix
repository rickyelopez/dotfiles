{ config, lib, ... }:
{
  config = lib.mkIf config.hostSpec.isServer { };
}
