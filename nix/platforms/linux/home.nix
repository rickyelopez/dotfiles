{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      ouch
      rustup
      trash-cli
    ];
  };

  services = {
    lorri.enable = true;
  };
}
