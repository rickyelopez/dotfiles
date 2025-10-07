{ lib, config, hostSpec, ... }:
let
  cfg = config.my.alacritty;
in
{
  options.my.alacritty = {
    enable = lib.mkEnableOption "home alacritty module.";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "alacritty";
        font = {
          normal = {
            family =
              if hostSpec.isDarwin then
                "BlexMono Nerd Font Propo"
              else
                "Blex Mono Nerd Font Propo";
            style = "Medium";
          };
          size = 10;
        };
        scrolling.history = 10000;
        window = {
          decorations = "none";
          opacity = 0.9;
          startup_mode = "Maximized";
          dynamic_padding = true;
          blur = true;
          padding = {
            x = 2;
            y = 2;
          };
        };
      };
    };
  };
}
