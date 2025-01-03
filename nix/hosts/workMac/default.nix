{ self, inputs, ... }:
let
  user = "ricky.lopez";
  home = "/Users/${user}";
in
inputs.darwin.lib.darwinSystem {
  specialArgs = { inherit self inputs home user; };
  modules = [
    ./configuration.nix
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${user}" = {
        imports = [ ./home.nix ];
      };

      home-manager.extraSpecialArgs = {
        inherit self
          inputs
          home
          user;
      };
    }
  ];
}
