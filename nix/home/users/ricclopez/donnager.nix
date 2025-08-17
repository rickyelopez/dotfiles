{ pkgs, ... }: {
  imports = [
    ../../../platforms/linux/home
  ];

  home = {
    packages = with pkgs; [
      buck2
      gcc
    ];
  };

  services = {
    # this is already enabled in nix/platforms/linux/home/headed.nix, but that file doesn't get
    # imported for donnager in the standalone home-manager config
    ssh-agent.enable = true;
  };

  my = {
    docker.enable = true;
    sops.enable = true;
    ssh.enable = true;
  };
}
