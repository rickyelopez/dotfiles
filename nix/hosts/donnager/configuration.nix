{ config, pkgs, inputs, lib, hostname, user, ... }:
{
  wsl.enable = true;

  networking.hostName = hostname; # Define your hostname.
  networking.hosts = {
    "10.19.21.31" = [ "sathub" "sathub.forestroot.elexpedition.com" ];
    "10.19.21.30" = [ "fob" "fob.forestroot.elexpedition.com" ];
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  wsl.defaultUser = user;
  users.users."${user}" = {
    isNormalUser = true;
    description = "ricclopez";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  nixpkgs = {
    config.allowUnfree = true; # Allow unfree packages
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer
    killall
    nodejs_23
    pkg-config
  ];

  programs = { zsh.enable = true; };

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
