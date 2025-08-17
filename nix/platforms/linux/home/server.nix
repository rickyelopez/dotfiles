{ pkgs, lib, ... }:
{
  home.file.".ssh/rc".source = ../../../../.ssh/rc;
  home.packages = with pkgs; [
    openssl
  ];

  my.zsh = {
    enable = true;
    minimal = lib.mkForce true;
  };
}
