{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.work;
  workSecret = name: config.sops.secrets."work/${name}".path;
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

      programs.zsh = {
        shellAliases = {
          zipcdb = "ninja -C out all_apps -t compdb | jq \'[ .[] | select(.command | contains(\"bad_toolchain\")|not) ]\' > compile_commands.json";
        };
        initContent = /* bash */ ''
          function devc() {
            bazel run //tools/ide:devcontainer -- "$@" '/home/vscode/data/bin/start.sh'
          }
        '';
      };
    })
    (lib.mkIf cfg.secrets.enable {
      programs.zsh = {
        initContent = /* bash */ ''
          export ARTIFACTORY_DEBIAN_TOKEN="$(<${workSecret "artifactory_debian_token"})"
          export GITHUB_TOKEN="$(<${workSecret "github_token"})"
          export DATALIB__BARAZA_API_TOKEN="$(<${workSecret "baraza_token"})"
          export BUILDKITE_API_TOKEN="$(<${workSecret "buildkite_token"})"
          export JIRA_API_KEY="$(<${workSecret "jira_token"})"
          export XRAY_CLIENT_ID="$(<${workSecret "xray_client_id"})"
          export XRAY_CLIENT_SECRET="$(<${workSecret "xray_client_secret"})"
        '';

        sessionVariables = {
          BUILDKITE_ORGANIZATION_SLUG = "flyzipline";
        };
      };

      sops.secrets = {
        "work/artifactory_debian_token" = { };
        "work/github_token" = { };
        "work/baraza_token" = { };
        "work/buildkite_token" = { };
        "work/jira_token" = { };
        "work/xray_client_id" = { };
        "work/xray_client_secret" = { };
      };

      my.sops.enable = true;
    })
  ];
}
