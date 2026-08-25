{
  config,
  lib,
  ...
}:
let
  cfg = config.my.tmux;
in
{
  options.my.tmux = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "home tmux module.";
      };
    };

  };

  config = lib.mkIf cfg.enable {
    home.file = config.lib.file.mkDotfilesSymlinks [
      ".config/tmux/extra.conf"
    ];

    programs.tmux = {
      enable = true;

      # leaving some configs I mess with more frequently in a separate file
      # so I don't need to rebuild to change them
      extraConfig = ''
        source-file ~/.config/tmux/extra.conf
      '';

      aggressiveResize = true;
      baseIndex = 1;
      customPaneNavigationAndResize = true;
      escapeTime = 0;
      focusEvents = true;
      historyLimit = 50000;
      keyMode = "vi";
      mouse = true;
      secureSocket = false;
      terminal = "tmux-256color";
    };
  };
}
