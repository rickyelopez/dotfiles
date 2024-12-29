{ nixpkgs, inputs, ... }:
let
  user = "ricclopez";
  home = "/home/${user}";
  hostname = "expedition";
in
nixpkgs.lib.nixosSystem
{
  specialArgs = { inherit inputs; inherit user; inherit home; inherit hostname;};
  modules = [
    ./configuration.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit inputs;
        inherit home;
        inherit user;
        inherit hostname;
      };

      home-manager.users."${user}" = import ./home.nix;
    }
  ];
}

