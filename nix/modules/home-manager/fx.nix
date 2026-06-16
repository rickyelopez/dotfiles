{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.fx;
  completion = pkgs.runCommand "fx-zsh-completion" { } ''
    ${lib.getExe pkgs.fx} --comp zsh > $out
  '';
in
{
  options.my.fx = {
    enable = lib.mkEnableOption "home fx module.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ fx ];

    programs.zsh.initContent = lib.mkOrder 1000 /* bash */ ''
      ${lib.optionalString config.my.zsh.zprof ''
        __zsh_profile_start "fx completion"
      ''}
      source ${completion}
      ${lib.optionalString config.my.zsh.zprof ''
        __zsh_profile_end "fx completion"
      ''}
    '';
  };
}
