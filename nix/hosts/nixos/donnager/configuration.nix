{ pkgs, config, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = config.hostSpec.username;

  networking.hostName = config.hostSpec.hostname;
  networking.hosts = {
    "10.19.21.31" = [ "sathub" "sathub.forestroot.elexpedition.com" ];
    "10.19.21.30" = [ "fob" "fob.forestroot.elexpedition.com" ];
  };

  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer
    killall
    nodejs_23
    pkg-config
  ];

  programs = { zsh.enable = true; };

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
}
