{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      dig
      ffmpegthumbnailer
      killall
      ncdu
      nfs-utils
      # nodejs_23
      nodePackages.npm
      pciutils
      pipx
      trash-cli
      usbutils
      util-linux
    ];
  };
}
