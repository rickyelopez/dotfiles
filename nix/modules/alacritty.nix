{ pkgs, ... }: {
  home = { };
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      font = {
        normal = {
          family =
            if pkgs.stdenv.isDarwin then
              "BlexMono Nerd Font Mono"
            else
              "Blex Mono Nerd Font Mono";
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
}
