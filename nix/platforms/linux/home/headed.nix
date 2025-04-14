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
      playerctl
      qalculate-gtk
      # rustdesk
      vlc
    ];
  };

  services = {
    ssh-agent.enable = true;
    nextcloud-client.enable = true;
  };

  xdg.desktopEntries = {
    brave-browser = {
      name = "Brave Web Browser";
      genericName = "Web Browser";
      type = "Application";
      exec = "${pkgs.brave}/bin/brave --password-store=gnome-libsecret %U";
      terminal = false;
      categories = [ "Network" "WebBrowser" ];
      startupNotify = true;
      icon = "brave-browser";
      actions = {
        "new-window" = {
          name = "New Window";
          exec = "${pkgs.brave}/bin/brave --password-store=gnome-libsecret";
        };
        "new-private-window" = {
          name = "New Private Window";
          exec = "${pkgs.brave}/bin/brave --password-store=gnome-libsecret --incognito";
        };
      };
      mimeType = [
        "text/html"
        "text/xml"
        "application/rdf+xml"
        "application/rss+xml"
        "application/xhtml+xml"
        "application/xhtml_xml"
        "application/xml"
        "image/gif"
        "image/jpeg"
        "image/png"
        "image/webp"
        "text/html"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };
  };
}
