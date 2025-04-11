{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      ffmpegthumbnailer
      gcc
      gdb
      killall
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
