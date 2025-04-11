{ pkgs, config, ... }: {
  imports = [
    {
      _module.args = {
        disk = "/dev/disk/by-id/nvme-CT1000P2SSD8_2139E5D674DF";
        withSwap = true;
        swapSizeGigabytes = 64;
      };
    }
    ../../../disks/nixos-luks-btrfs.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [ ];

  programs = { zsh.enable = true; };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  networking.networkmanager.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services = {
    # TODO: figure out what to do about keyring
    # gnome.gnome-keyring.enable = true;
    upower.enable = true;
  };
}
