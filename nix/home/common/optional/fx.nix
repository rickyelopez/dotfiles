{ pkgs, lib, ... }: {
  home.packages = with pkgs; [ fx ];
  programs.zsh.initContent = lib.mkOrder 1000
    /*bash*/ ''
    source <(fx --comp zsh)
  '';
}
