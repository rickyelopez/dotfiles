{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      dig
      ffmpegthumbnailer
      killall
      nfs-utils
      nodejs_25
      pciutils
      pipx
      trash-cli
      usbutils
      util-linux
    ];
  };
}
