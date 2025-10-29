{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];
  wsl = {
    enable = true;
    defaultUser = config.hostSpec.username;
    wslConf = {
      network = {
        generateHosts = false;
        generateResolvConf = false;
      };
    };
  };

  boot.supportedFilesystems = [ "nfs" ];
  environment.systemPackages = with pkgs; [ nfs-utils ];
  services.rpcbind.enable = true;

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  networking = {
    nameservers = [ "10.19.21.6" ];
    search = [ "forestroot.elexpedition.com" ];
  };
}
