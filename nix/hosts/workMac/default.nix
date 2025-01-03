{ nixpkgs, inputs, ... }:
let
  user = "ricky.lopez";
  home = "/Users/${user}";
in
{
  "Ricky-Lopez-DTQ4WX0376" = inputs.darwin.lib.darwinSystem {
    specialArgs = { inherit inputs; inherit home; inherit user; };
    modules = [
      ../../modules/nix-core.nix
      ../../modules/darwin.nix
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."${user}" = import ../../home.nix;

        home-manager.extraSpecialArgs = {
          inherit inputs;
          inherit home;
          inherit user;
        };
      }
    ];
  };
}

