{
  config,
  lib,
  ...
}:
let
  cfg = config.my.work;
in
{
  options.my.work = {
    secrets.enable = lib.mkEnableOption "home work secrets module.";
  };

  config = lib.mkIf cfg.secrets.enable {
    programs.zsh.initContent = /* bash */ ''
      export GITHUB_TOKEN="$(cat ${config.sops.secrets."work/github_token".path})"
      export DATALIB__BARAZA_API_TOKEN="$(cat ${config.sops.secrets."work/baraza_token".path})"
    '';

    sops.secrets = {
      "work/github_token" = { };
      "work/baraza_token" = { };
    };

    my.sops.enable = true;
  };
}
