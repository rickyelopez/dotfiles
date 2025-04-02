{ nixpkgs, inputs, ... }:
let
  user = "ricclopez";
  home = "/home/${user}";
in
inputs.home-manager.lib.homeManagerConfiguration rec {
  pkgs = import nixpkgs { system = "x86_64-linux"; };
  extraSpecialArgs = { inherit user home inputs; };
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
}
