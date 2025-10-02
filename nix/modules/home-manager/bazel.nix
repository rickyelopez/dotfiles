{ config, lib, pkgs, ... }:
let
  cfg = config.my.bazel;
in
{
  options.my.bazel = {
    enable = lib.mkEnableOption "home bazel module.";
    bazelisk = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether or not to enable bazelisk";
    };
  };

  config.home = lib.mkIf cfg.enable {
    packages = [ pkgs.bazelisk ];

    shellAliases = {
      bazel = "bazelisk";
    };
  };
}
