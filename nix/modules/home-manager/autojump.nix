{
  config,
  lib,
  ...
}:
let
  cfg = config.my.autojump;
in
{
  options.my.autojump = {
    enable = lib.mkEnableOption "home autojump module.";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      autojump = {
        enable = true;
        enableZshIntegration = false;
      };

      zsh.initContent = lib.mkOrder 1000 /* bash */ ''
        ${lib.optionalString config.my.zsh.zprof ''
          __zsh_profile_start "autojump source"
        ''}
        . ${config.programs.autojump.package}/share/autojump/autojump.zsh
        ${lib.optionalString config.my.zsh.zprof ''
          __zsh_profile_end "autojump source"
        ''}
      '';
    };
  };
}
