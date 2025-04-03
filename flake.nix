{
  description = "Dotfiles Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpolkitagent = {
      url = "github:hyprwm/hyprpolkitagent";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    madness.url = "github:antithesishq/madness";
  };

  outputs =
    inputs @ { self
    , darwin
    , nixos-wsl
    , lix-module
    , nixpkgs
    , home-manager
    , ...
    }:
    {
      nixosConfigurations = builtins.listToAttrs (
        map
          (host: {
            name = host;
            value = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs host; isDarwin = false; };
              modules = [ ./nix/hosts/nixos/${host} ];
            };
          })
          (builtins.attrNames (builtins.readDir ./nix/hosts/nixos))
      );

      darwinConfigurations = builtins.listToAttrs (
        map
          (host: {
            name = host;
            value = darwin.lib.darwinSystem {
              specialArgs = { inherit inputs host; isDarwin = true; };
              modules = [ ./nix/hosts/darwin/${host} ];
            };
          })
          (builtins.attrNames (builtins.readDir ./nix/hosts/darwin))
      );

      # Expose the package set, including overlays, for convenience.
      # I still don't know what this does. Do I actually need this??
      darwinPackages = self.darwinConfigurations."Ricky-Lopez-DTQ4WX0376".pkgs;

      # packages.x86_64-linux.default = home-manager.packages.x86_64-linux.default;
      # homeConfigurations = {
      #   "ricclopez@thinkrick" = import ./nix/hosts/thinkrick { inherit self nixpkgs inputs; };
      # }; #// hosts.donnager.homeConfigurations;
    };
}
