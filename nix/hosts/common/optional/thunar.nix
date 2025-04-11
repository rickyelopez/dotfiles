{ pkgs, ... }: {
  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
    xfconf.enable = true;

  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  xdg.mime = {
    defaultApplications = {
      "inode/directory" = "thunar.desktop";
    };
  };
}
