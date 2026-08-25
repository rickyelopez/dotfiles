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
    rev = "dd2d6cf07f81cef543e37883352e30b91634ec86";
    hash = "sha256-sB2t3Gg+WdPG6OE8pD6VovD+x9nN21Jn8XydZZdTqCg=";
  };

  meta = {
    description = "A Yazi plugin that enhances Yazi's default commands.";
    homepage = "https://github.com/hankertrix/augment-command.yazi";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rickyelopez ];
  };
}
