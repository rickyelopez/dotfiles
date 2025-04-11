{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      brave
      feh
      gedit
      ghostty
      nextcloud-client
      pamixer
      pavucontrol
      qalculate-gtk
      rustdesk
      vlc
    ];
  };
  services = {
    ssh-agent.enable = true;
  };
}
