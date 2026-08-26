{
  hostSpec,
  config,
  options,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.stylix;
in
{
  options.my.stylix = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "home stylix module.";
      };
    };

  };

  config =
    if options ? stylix then
      (lib.mkIf cfg.enable {
        stylix = {
          targets = {
            neovim.enable = false;
          };
        }
        // (
          if (hostSpec.isStandaloneHm) then
            {
              enable = true;
              polarity = "dark";
              base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-moon.yaml";
            }
          else
            { }
        );
      })
    else
      { };
}
