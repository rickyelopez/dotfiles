{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      dig
      ffmpegthumbnailer
      inotify-tools
      killall
      nfs-utils
      nodejs_26
      pciutils
      pipx
      trash-cli
      usbutils
      util-linux
    ];
  };
}
