{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      python314
      python314Packages.pip
      uv
    ];
  };

  my.docker.enable = true;
}
