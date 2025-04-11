{ outputs, ... }: {
  networking.hosts = {
    "10.19.21.31" = [ "sathub" "sathub.forestroot.elexpedition.com" ];
    "10.19.21.30" = [ "fob" "fob.forestroot.elexpedition.com" ];
  };

  nixpkgs.overlays = [ outputs.overlays.default ];
  programs.nix-ld.enable = true;

  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };


  # Select locale properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}
