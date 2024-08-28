{ config, home, inputs, ... }: {
  home = {
    sessionVariables = { TERM = "wezterm"; };
    # I don't want to put my wezterm lua config in a string in this file, and there's no way to prevent
    # home manager from creating the `wezterm.lua` file with the default contents. Instead, link this `config.lua`
    # file which contains the actual wezterm config, and stub out `wezterm.lua` so that all it does is require
    # this file
    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/wezterm/config.lua".source = mkLink "${home}/dotfiles/.config/wezterm/config.lua";
    };
  };

  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.aarch64-darwin.default;
    extraConfig = ''
      local config = require("config")
      return config
    '';
  };
}
