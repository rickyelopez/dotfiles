{ config, home, inputs, lib, ... }: {
  # home = {
  #   sessionVariables = {  };
  #   file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
  #     ".config/wezterm/wezterm.lua".source = mkLink "${home}/dotfiles/.config/wezterm/wezterm.lua";
  #   };
  # };

  # xdg.configFile."wezterm/wezterm.lua".enable = false;

  programs.zsh = {
    enable = false;
  };

  environment.pathsToLink = [ "/share/zsh" ];
}

