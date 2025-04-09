{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      ouch
      rustup
      trash-cli
      util-linux
    ];
  };

  services = {
    lorri.enable = true;
  };
}
