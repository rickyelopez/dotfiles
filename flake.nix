{
  description = "Dotfiles Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
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

    madness = {
      url = "github:antithesishq/madness";
    };
  };

  outputs =
    inputs @ { self
    , darwin
    , nixpkgs
    , home-manager
    , ...
    }:
    {
      nixosConfigurations = {
        expedition = import ./nix/hosts/expedition { inherit nixpkgs; inherit inputs; };
      };
      darwinConfigurations = {
        "Ricky-Lopez-DTQ4WX0376" = import ./nix/hosts/workMac { inherit self; inherit nixpkgs; inherit inputs; };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Ricky-Lopez-DTQ4WX0376".pkgs;

      defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
      homeConfigurations = {
        "ricclopez@donnager" = import ./nix/hosts/donnager { inherit self nixpkgs inputs; };
        "ricclopez@thinkrick" = import ./nix/hosts/thinkrick { inherit self nixpkgs inputs; };
      };
    };
}
