{ config, home, inputs, ... }: {
  home = {
    # sessionVariables = { TERM = "wezterm"; };
    # activation.removeExistingWeztermConfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    #   rm -f ~/.config/wezterm/wezterm.lua
    # '';
    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/wezterm/wezterm.lua".source = mkLink "${home}/dotfiles/.config/wezterm/wezterm.lua";
    };
  };

  # disable automatic generation of the wezterm.lua file by home manager. Manually link the file instead (see above)
  xdg.configFile."wezterm/wezterm.lua".enable = false;

  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.aarch64-darwin.default;
  };
}
