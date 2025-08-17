{ pkgs, lib, config, ... }:
let
  cfg = config.my.fx;
in
{
  options.my.fx = {
    enable = lib.mkEnableOption "home fx module.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ fx ];

    programs.zsh.initContent = lib.mkOrder 1000
      /*bash*/ ''
      source <(fx --comp zsh)
    '';
  };
}
