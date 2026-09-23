{
  hostSpec,
  lib,
  ...
}:
let
  user = hostSpec.username;
in
{
  imports = [
    ./users/${user}/${hostSpec.hostname}.nix
    (lib.custom.relativeToRoot "platforms/common/home")
  ];

  home = {
    username = user;
    homeDirectory = hostSpec.home;
    stateVersion = "24.05"; # don't change
  };
}
