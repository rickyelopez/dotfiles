{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      gdb
      ouch
      pkg-config
      rustup
    ];
  };

  services = {
    lorri.enable = true;
  };
}
