{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-ld.url = "github:Mic92/nix-ld/main";
    nvim-traxys = {
      url = "github:traxys/nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zsh-traxys = {
      url = "github:traxys/zsh-flake";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
    naersk.url = "github:nix-community/naersk";
    comma.url = "github:nix-community/comma";
    raclette.url = "github:traxys/raclette";
    poetry2nix.url = "github:nix-community/poetry2nix";
    nur.url = "github:nix-community/NUR";

    # Extra Package Sources
    simulationcraft = {
      url = "github:simulationcraft/simc";
      flake = false;
    };
    oscclip = {
      url = "github:rumpelsepp/oscclip";
      flake = false;
    };
    kabalist = {
      url = "github:traxys/kabalist";
      flake = false;
    };
    xdg-ninja = {
      url = "github:b3nj5m1n/xdg-ninja";
      flake = false;
    };
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    sources =
      {
        inherit (inputs) oscclip xdg-ninja simulationcraft kabalist;
      }
      // (nixpkgs.legacyPackages.x86_64-linux.callPackage ./_sources/generated.nix {});
  in {
    templates = {
      rust = {
        path = ./templates/rust;
        description = "My rust template using rust-overlay and direnv";
      };
    };
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      import ./pkgs/default.nix {
        inherit sources;
        callPackage = pkgs.callPackage;
        naersk = inputs.naersk.lib.x86_64-linux;
      };
    nixosConfigurations = {
      ZeNixLaptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ({pkgs, ...}: {
            nixpkgs.overlays = [
              inputs.nur.overlay
              inputs.rust-overlay.overlays.default
              inputs.nvim-traxys.overlay."${system}"
              inputs.nix-alien.overlay
              inputs.nix-gaming.overlays.default
              inputs.comma.overlays.default
              inputs.poetry2nix.overlay
              (final: prev:
                import ./pkgs/default.nix {
                  inherit sources;
                  callPackage = prev.callPackage;
                  naersk = inputs.naersk.lib."${system}";
                })
              (final: prev: {
                raclette = inputs.raclette.defaultPackage."${system}";
              })
            ];
          })
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.traxys = {
              config,
              lib,
              pkgs,
              ...
            }: {
              imports = [
                ./home.nix
                ./graphical.nix
                ./extra_info.nix
                ./localinfo.nix
                ./wm
                ./rustdev.nix
                ./git
                inputs.zsh-traxys.home-managerModule."${system}"
                inputs.nvim-traxys.home-managerModule."${system}"
              ];
            };
            home-manager.extraSpecialArgs = {flake = self;};
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
