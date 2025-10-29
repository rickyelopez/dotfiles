{ hostSpec, ... }:
{
  imports = [
    ./common.nix
  ]
  ++ (if hostSpec.isHeadless then [ ./headless.nix ] else [ ./headed.nix ])
  ++ (if hostSpec.isServer then [ ./server.nix ] else [ ./station.nix ]);
}
