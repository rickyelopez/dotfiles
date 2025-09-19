{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      gdb
      # nodejs_23
      nodePackages.npm
      ouch
      pkg-config
      python313
      rustup
    ];
  };

  services = {
    lorri.enable = true;
  };
}

