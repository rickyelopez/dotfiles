{ pkgs, ... }:
{
  imports = [
    ../../../home/common/optional/zsh-minimal.nix
  ];

  home.file.".ssh/rc".source = ../../../../.ssh/rc;
  home.packages = with pkgs; [
    openssl
  ];
}
