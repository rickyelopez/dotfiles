{
  hostSpec,
  pkgs,
  lib,
  ...
}:
{
  home = {
    packages =
      with pkgs;
      [
        brave
        gedit
        ghostty
        ksnip
        imv
        pamixer
        pavucontrol
        playerctl
        qalculate-qt
        # rustdesk
        vlc
      ]
      ++ lib.optionals (!hostSpec.isWork) [ rustdesk-flutter ];
  };

  services = {
    ssh-agent.enable = true;
    nextcloud-client.enable = true;
  };

  xdg.desktopEntries = {
    brave-browser =
      let
        baseCmd = "${pkgs.brave}/bin/brave --password-store=gnome-libsecret --ozone-platform=x11 ";
      in
      {
        name = "Brave Web Browser";
        genericName = "Web Browser";
        type = "Application";
        exec = "${baseCmd} %U";
        terminal = false;
        categories = [
          "Network"
          "WebBrowser"
        ];
        startupNotify = true;
        icon = "brave-browser";
        actions = {
          "new-window" = {
            name = "New Window";
            exec = "${baseCmd}";
          };
          "new-private-window" = {
            name = "New Private Window";
            exec = "${baseCmd} --incognito";
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
