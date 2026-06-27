{
  config,
  lib,
  ...
}:
let
  cfg = config.my.direnv;
in
{
  options.my.direnv = {
    enable = lib.mkEnableOption "home direnv module.";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        enableZshIntegration = false;
        nix-direnv.enable = true;
      };

      zsh.initContent = lib.mkOrder 1000 /* bash */ ''
        ${lib.optionalString config.my.zsh.zprof ''
          __zsh_profile_start "direnv hook"
        ''}
        eval "$(${lib.getExe config.programs.direnv.package} hook zsh)"
        ${lib.optionalString config.my.zsh.zprof ''
          __zsh_profile_end "direnv hook"
        ''}
      '';
    };
  };
}
