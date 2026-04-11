{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      gdb
      ouch
      pkg-config
      python313
      rustup
    ];
  };

  services = {
    lorri.enable = true;
  };
}
