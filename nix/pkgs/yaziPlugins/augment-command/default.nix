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
    rev = "04cda986fcf9e682373e95c1c7d7dd60eeff36cc";
    hash = "sha256-LA5rKynrzsHiQvb0WzrJWmOPxutlRljJWKLXMMe1IAo=";
  };

  meta = {
    description = "A Yazi plugin that enhances Yazi's default commands.";
    homepage = "https://github.com/hankertrix/augment-command.yazi";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rickyelopez ];
  };
}
