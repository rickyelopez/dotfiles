{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      gcc
    ];
  };

  services = {
    # this is already enabled in nix/platforms/linux/home/headed.nix, but that file doesn't get
    # imported for donnager in the standalone home-manager config
    ssh-agent.enable = true;
  };

  imports = [
    ../../../home
    ../../optional/ssh.nix
    ../../optional/sops.nix
    ../../../platforms/linux/home
  ];
}
