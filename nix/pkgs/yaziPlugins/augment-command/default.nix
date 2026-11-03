{
  lib,
  fetchFromGitHub,
  pkgs,
  mkYaziPlugin ? pkgs.yaziPlugins.mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "augment-command";
  version = "main";

  src = fetchFromGitHub {
    owner = "hankertrix";
    repo = "augment-command.yazi";
    rev = "1bb193e2b89d14f1da712fe1c324f625c63bf3f6";
    hash = "sha256-DLDJBz7+gqyJzGCW1I3G2/CRK3ks5HGtEjK/vOChTMo=";
  };

  meta = {
    description = "A Yazi plugin that enhances Yazi's default commands.";
    homepage = "https://github.com/hankertrix/augment-command.yazi";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rickyelopez ];
  };
}
