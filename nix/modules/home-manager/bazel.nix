{ lib, pkgs, ... }:
{
  options.my.bazel = {
    enable = lib.mkEnableOption "home bazel module.";
    bazelisk = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether or not to enable bazelisk";
    };
  };

  config = {
    home = {
      packages = [ pkgs.bazelisk ];

      shellAliases = {
        bazel = "bazelisk";
      };
    };
  };
}
