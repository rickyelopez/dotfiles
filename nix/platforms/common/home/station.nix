{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      tuicr
    ];
  };
}
