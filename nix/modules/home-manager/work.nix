{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.work;
in
{
  options.my.work = {
    enable = lib.mkEnableOption "home work module.";
    secrets.enable = lib.mkEnableOption "home work secrets module.";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        opencode
      ];
    })
    (lib.mkIf cfg.secrets.enable {
      programs.zsh = {
        initContent = /* bash */ ''
          export GITHUB_TOKEN="$(cat ${config.sops.secrets."work/github_token".path})"
          export DATALIB__BARAZA_API_TOKEN="$(cat ${config.sops.secrets."work/baraza_token".path})"
          export BUILDKITE_API_TOKEN="$(cat ${config.sops.secrets."work/buildkite_token".path})"
          export JIRA_API_TOKEN="$(cat ${config.sops.secrets."work/jira_token".path})"
        '';

        sessionVariables = {
          BUILDKITE_ORGANIZATION_SLUG = "flyzipline";
        };
      };

      sops.secrets = {
        "work/github_token" = { };
        "work/baraza_token" = { };
        "work/buildkite_token" = { };
        "work/jira_token" = { };
      };

      my.sops.enable = true;
    })
  ];
}
