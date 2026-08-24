{
  lib,
  config,
  hostSpec,
  ...
}:
let
  cfg = config.my.gtk;
  user = hostSpec.username;
in
{
  options.my.gtk = {
    enable = lib.mkEnableOption "home gtk module.";
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      gtk3 = {
        bookmarks = [
          "file:///home/${user}/Nextcloud"
          "file:///home/${user}/Downloads"
        ];
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };
    };
  };
}
