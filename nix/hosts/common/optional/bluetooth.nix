{ ... }: {
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings.General.Experimental = true; # enable bluetooth device battery display
  };

  services.blueman.enable = true;
}
