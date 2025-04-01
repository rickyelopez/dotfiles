{ nixpkgs, home-manager, nixos-wsl, lix-module, inputs, ... }:
let
  user = "ricclopez";
  home = "/home/${user}";
  hostname = "donnager";
in
{
  homeConfigurations = {
    "ricclopez@donnager" = home-manager.lib.homeManagerConfiguration rec {
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      extraSpecialArgs = { inherit user home; };

      modules = [
        {
          nixpkgs.config.allowUnfree = true;

          nix = {
            package = pkgs.nix;
            settings = {
              experimental-features = [ "nix-command" "flakes" ];
              # auto-optimise-store = false;
              warn-dirty = false;
            };
            gc = {
              automatic = true;
              options = "--delete-older-than 7d";
            };
          };
        }
        ./home.nix
      ];
    };
  };

  nixosConfigurations = {
    donnager = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs user home hostname; };
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        nixos-wsl.nixosModules.default
        lix-module.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs home user hostname; };

          home-manager.users."${user}" = import ./home.nix;
        }
      ];
    };
  };
}
