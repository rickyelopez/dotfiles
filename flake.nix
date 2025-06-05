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

    disko = {
      url = "github:nix-community/disko/latest";
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
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
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

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs @ { self
    , darwin
    , nixpkgs
    , home-manager
    , ...
    }:
    let
      inherit (self) outputs;
    in
    {
      overlays = import ./nix/overlays { inherit inputs; };

      # nixos configurations for each host
      # hosts are defined in ./nix/hosts/nixos
      nixosConfigurations = builtins.listToAttrs (
        map
          (host: {
            name = host;
            value = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs outputs host; isDarwin = false; isStandaloneHm = false; };
              modules = [ ./nix/hosts/nixos/${host} ];
            };
          })
          (builtins.attrNames (builtins.readDir ./nix/hosts/nixos))
      );

      # nix-darwin configurations for each host
      # hosts are defined in ./nix/hosts/darwin
      darwinConfigurations = builtins.listToAttrs (
        map
          (host: {
            name = host;
            value = darwin.lib.darwinSystem {
              specialArgs = { inherit self inputs outputs host; isDarwin = true; isStandaloneHm = false; isWork = true; };
              modules = [ ./nix/hosts/darwin/${host} ];
            };
          })
          (builtins.attrNames (builtins.readDir ./nix/hosts/darwin))
      );

      # Expose the package set, including overlays, for convenience.
      # I still don't know what this does. Do I actually need this??
      darwinPackages = self.darwinConfigurations."Ricky-Lopez-DTQ4WX0376".pkgs;

      # standalone home-manager configs
      # user@host combos are defined below, since the configuration is (so far, at least)
      # identical across all the combos
      packages.x86_64-linux.default = home-manager.packages.x86_64-linux.default;

      homeConfigurations = builtins.listToAttrs (
        map
          (instance: {
            name = "${instance.username}@${instance.hostname}";
            value = home-manager.lib.homeManagerConfiguration rec {
              pkgs = import nixpkgs { system = "x86_64-linux"; };
              extraSpecialArgs = {
                inherit inputs;
                isDarwin = false;
                isStandaloneHm = true;
                hostSpec = {
                  home = "/home/${instance.username}";
                  isDarwin = false;
                  isStandaloneHm = true;
                  isServer = false;
                } // instance;
                monitors = [ ];
              };
              modules = [
                {
                  imports = [
                    ./nix/hosts/common/core
                    ./nix/home/users/${instance.username}/${instance.hostname}.nix
                  ];

                  nix = {
                    package = pkgs.nix;
                  };

                  nixpkgs.overlays = [ outputs.overlays.default ];
                }
              ];
            };
          })
          [
            { username = "ricclopez"; hostname = "donnager"; isHeadless = true; isWork = false; domain = "forestroot.elexpedition.com"; }
            { username = "ricclopez"; hostname = "thinkrick"; isHeadless = true; isWork = true; domain = ""; }
          ]
      );
    };
}
