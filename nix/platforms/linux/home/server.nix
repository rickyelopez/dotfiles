{ ... }:
{
  imports = [
    ../../../home/optional/zsh-minimal.nix
  ];

  home.file.".ssh/rc".source = ../../../../.ssh/rc;
}
