{ lib, hostSpec, ... }: {
  imports = [ ./common.nix ]
    ++ lib.optionals (hostSpec.isHeadless) [ ./headless.nix ]
    ++ lib.optionals (!hostSpec.isHeadless) [ ./headed.nix ]
    ++ lib.optionals (hostSpec.isServer) [ ./server.nix ];
}
