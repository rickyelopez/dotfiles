{ nixpkgs, inputs, ... }:
let
  user = "ricclopez";
  home = "/home/${user}";
  hostname = "expedition";
in
nixpkgs.lib.nixosSystem
{
  specialArgs = { inherit inputs user home hostname; };
  modules = [
    ./configuration.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs home user hostname; };

      home-manager.users."${user}" = import ./home.nix;
    }
  ];
}

