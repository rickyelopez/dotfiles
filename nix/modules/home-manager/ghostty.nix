{
  hostSpec,
  config,
  options,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.ghostty;
in
{
  options.my.ghostty = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "home ghostty module.";
      };
    };

  };

  config = lib.mkIf cfg.enable (
    {
      home.file = {
        ".config/ghostty/extra.conf" = {
          source = config.lib.file.mkOutOfStoreSymlink "${hostSpec.home}/dotfiles/.config/ghostty/config";
        };
      };

      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
        package = if hostSpec.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
        settings = {

          font-family = "BlexMono Nerd Font Propo";
          font-style = "Medium";
          font-size = 10;

          window-decoration = false;
          window-padding-balance = true;

          background-opacity = 1;

          clipboard-read = "allow";
          clipboard-paste-protection = true;

          app-notifications = "no-clipboard-copy";
          config-file = "~/.config/ghostty/extra.conf";
        };
      };
    }
    // (
      if (options ? stylix) then
        {
          stylix.targets.ghostty.fonts.enable = false;
        }
      else
        { }
    )
  );
}
