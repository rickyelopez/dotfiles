{ pkgs, ... }: {
  home.packages = with pkgs; [ fx ];
  programs.zsh.initExtra = '' source <(fx --comp zsh) '';
}
