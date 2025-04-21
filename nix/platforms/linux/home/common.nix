{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      ffmpegthumbnailer
      gcc
      gdb
      killall
      ncdu
      nfs-utils
      # nodejs_23
      nodePackages.npm
      ouch
      pipx
      pkg-config
      python313
      rustup
      trash-cli
      usbutils
      util-linux
    ];
  };

  services = {
    lorri.enable = true;
  };
}
