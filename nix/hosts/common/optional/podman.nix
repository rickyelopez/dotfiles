{ pkgs, config, ... }: {
  users.users.${config.hostSpec.username}.extraGroups = [ "podman" ];
  environment.variables = {
    PODMAN_COMPOSE_WARNING_LOGS = "false";
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerSocket.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    dive
    podman-tui
    podman-compose
  ];

  virtualisation.containers.storage.settings = {
    storage = {
      driver = "overlayfs";
      graphroot = "/var/lib/containers/storage";
      runroot = "/run/containers/storage";
    };
  };
}
