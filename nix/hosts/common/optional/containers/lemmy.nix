{ ... }: {
  networking.firewall.allowedTCPPorts = [
    10633 # lemmy server
  ];
}
