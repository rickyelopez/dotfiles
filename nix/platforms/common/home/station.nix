{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      feishin
      obsidian
      sqlitebrowser
    ];
  };
}
