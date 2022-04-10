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
    rust-overlay.url = "github:oxalica/rust-overlay";
    naersk.url = "github:nix-community/naersk";
    comma.url = "github:nix-community/comma";
    raclette.url = "github:traxys/raclette";
    nur.url = "github:nix-community/NUR";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

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
    roaming_proxy.url = "github:traxys/roaming_proxy";
    dotacat = {
      url = "git+https://gitlab.scd31.com/stephen/dotacat.git";
      flake = false;
    };
    zsh-nix-shell = {
      url = "github:chisui/zsh-nix-shell";
      flake = false;
    };
    powerlevel10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };
    fast-syntax-highlighting = {
      url = "github:zdharma-continuum/fast-syntax-highlighting";
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
        inherit (inputs) oscclip simulationcraft kabalist dotacat;
      }
      // (nixpkgs.legacyPackages.x86_64-linux.callPackage ./_sources/generated.nix {});

    pkgList = system: callPackage:
      (import ./pkgs/default.nix {
        inherit sources callPackage;
        naersk = inputs.naersk.lib."${system}";
      })
      // {
        raclette = inputs.raclette.defaultPackage."${system}";
        neovimTraxys = inputs.nvim-traxys.packages."${system}".nvim;
        roaming_proxy = inputs.roaming_proxy.defaultPackage."${system}";
      };

    extraInfo = import ./extra_info.nix;
  in {
    templates = {
      rust = {
        path = ./templates/rust;
        description = "My rust template using rust-overlay and direnv";
      };
    };
    packages.x86_64-linux = pkgList "x86_64-linux" nixpkgs.legacyPackages.x86_64-linux.callPackage;

    hmModules = {
      minimal = import ./minimal/hm.nix {
        inherit inputs;
        flake = self;
      };
      personal-cli = import ./personal-cli/hm.nix;
      personal-gui = import ./personal-gui/hm.nix;
      gaming = import ./gaming/hm.nix;
    };

    nixosModules = {
      minimal = import ./minimal/nixos.nix {
        inherit extraInfo;
      };
      personal-cli = import ./personal-cli/nixos.nix;
      personal-gui = import ./personal-gui/nixos.nix;
      roaming = import ./roaming/nixos.nix;
      gaming = import ./gaming/nixos.nix;
    };

    overlays.x86_64-linux = final: prev: pkgList "x86_64-linux" prev.callPackage;

    nixosConfigurations = let
      commonHmModules = [
        self.hmModules.minimal
        ./home.nix
        ./extra_info.nix
        ./localinfo.nix
        ./rustdev.nix
        ./git
      ];
    in {
      ZeNixLaptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hostconfig/ZeNixComputa/extra_info.nix
          self.nixosModules.minimal
          self.nixosModules.personal-cli
          self.nixosModules.personal-gui
          self.nixosModules.gaming
          ({pkgs, ...}: {
            nixpkgs.overlays = [
              inputs.nur.overlay
              inputs.rust-overlay.overlays.default
              inputs.nix-alien.overlay
              inputs.nix-gaming.overlays.default
              inputs.comma.overlays.default
              (final: prev: pkgList system prev.callPackage)
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
              imports =
                commonHmModules
                ++ [
                  self.hmModules.personal-cli
                  self.hmModules.personal-gui
                  self.hmModules.gaming
                ];
            };
            home-manager.extraSpecialArgs = {
              flake = self;
            };
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };

      ZeNixComputa = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hostconfig/ZeNixComputa/extra_info.nix
          self.nixosModules.minimal
          self.nixosModules.personal-cli
          self.nixosModules.personal-gui
          self.nixosModules.gaming
          ({pkgs, ...}: {
            nixpkgs.overlays = [
              inputs.nur.overlay
              inputs.rust-overlay.overlays.default
              inputs.nix-alien.overlay
              inputs.nix-gaming.overlays.default
              inputs.comma.overlays.default
              (final: prev: pkgList system prev.callPackage)
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
              imports =
                commonHmModules
                ++ [
                  self.hmModules.personal-cli
                  self.hmModules.personal-gui
                  self.hmModules.gaming
                ];
            };
            home-manager.extraSpecialArgs = {
              flake = self;
            };
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
