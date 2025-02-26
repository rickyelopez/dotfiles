{ pkgs, config, home, ... }: {
  home = {
    packages = with pkgs; [ yazi ];

    file = let mkLink = config.lib.file.mkOutOfStoreSymlink; in {
      ".config/yazi/init.lua".source = mkLink "${home}/dotfiles/.config/yazi/init.lua";
      ".config/yazi/keymap.toml".source = mkLink "${home}/dotfiles/.config/yazi/keymap.toml";
      ".config/yazi/package.toml".source = mkLink "${home}/dotfiles/.config/yazi/package.toml";
      ".config/yazi/yazi.toml".source = mkLink "${home}/dotfiles/.config/yazi/yazi.toml";
    };
  };
}
