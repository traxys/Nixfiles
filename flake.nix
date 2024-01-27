{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-traxys.url = "github:traxys/nixpkgs/inflight";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld = {
      url = "github:Mic92/nix-ld/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-traxys = {
      url = "github:traxys/nvim-flake";
      inputs.nixfiles.follows = "/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    comma = {
      url = "github:nix-community/comma";
      inputs.naersk.follows = "naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    raclette = {
      url = "github:traxys/raclette";
      inputs.naersk.follows = "naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # Extra Package Sources
    meson-syntax = {
      url = "github:Monochrome-Sauce/sublime-meson";
      flake = false;
    };
    glaurung.url = "git+https://gitea.familleboyer.net/traxys/Glaurung";
    simulationcraft = {
      url = "github:simulationcraft/simc";
      flake = false;
    };
    kabalist = {
      url = "github:traxys/kabalist";
      flake = false;
    };
    roaming_proxy = {
      url = "github:traxys/roaming_proxy";
      inputs.naersk.follows = "naersk";
      inputs.nixpkgs.follows = "nixpkgs";
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
    jq-zsh-plugin = {
      url = "github:reegnz/jq-zsh-plugin";
      flake = false;
    };
    mujmap = {
      url = "github:elizagamedev/mujmap";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    fioul.url = "github:traxys/fioul";
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    nixpkgs-traxys,
    ...
  } @ inputs: let
    sources = system:
      {
        inherit (inputs) simulationcraft kabalist;
      }
      // (nixpkgs.legacyPackages."${system}".callPackage ./_sources/generated.nix {});

    pkgList = system: callPackage:
      (import ./pkgs/default.nix {
        inherit callPackage;
        sources = sources system;
        naersk = inputs.naersk.lib."${system}";
      })
      // {
        glaurung = inputs.glaurung.defaultPackage."${system}";
        raclette = inputs.raclette.defaultPackage."${system}";
        neovimTraxys = inputs.nvim-traxys.packages."${system}".nvim;
        roaming_proxy = inputs.roaming_proxy.defaultPackage."${system}";
        inherit (nixpkgs-traxys.legacyPackages."${system}") groovy-language-server;
        inherit (inputs.mujmap.packages."${system}") mujmap;
      };

    extraInfo = import ./extra_info.nix;
  in {
    templates = {
      rust = {
        path = ./templates/rust;
        description = "My rust template using rust-overlay and direnv";
      };
      perseus = {
        path = ./templates/perseus;
        description = "A perseus frontend with rust-overlay & direnv";
      };
      webapp = {
        path = ./templates/webapp;
        description = "A template for a web application (frontend + backend)";
      };
      webserver = {
        path = ./templates/webserver;
        description = "A template for a web server (using templates for the frontend)";
      };
      gui = {
        path = ./templates/gui;
        description = "A template for rust GUI applications";
      };
    };
    packages.x86_64-linux = pkgList "x86_64-linux" nixpkgs.legacyPackages.x86_64-linux.callPackage;
    packages.aarch64-linux = pkgList "aarch64-linux" nixpkgs.legacyPackages.aarch64-linux.callPackage;

    hmModules = {
      minimal = import ./minimal/hm.nix {
        inherit inputs extraInfo;
        flake = self;
      };
      personal-cli = import ./personal-cli/hm.nix;
      personal-gui = import ./personal-gui/hm.nix;
      gaming = import ./gaming/hm.nix;
      work = import ./hostconfig/thinkpad-nixos/work.nix;
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
    overlays.aarch64-linux = final: prev: pkgList "aarch64-linux" prev.callPackage;

    nixosConfigurations = {
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
              inputs.comma.overlays.default
              (final: prev: pkgList system prev.callPackage)
              (final: prev: inputs.nix-gaming.packages."${system}")
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
                self.hmModules.minimal
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
          ./hostconfig/ZeNixComputa/hardware-configuration.nix
          ./hostconfig/ZeNixComputa/nixos.nix
          self.nixosModules.minimal
          self.nixosModules.personal-cli
          self.nixosModules.personal-gui
          self.nixosModules.gaming
          ({pkgs, ...}: {
            nixpkgs.overlays = [
              inputs.nur.overlay
              inputs.rust-overlay.overlays.default
              inputs.comma.overlays.default
              (final: prev: pkgList system prev.callPackage)
              (final: prev: inputs.nix-gaming.packages."${system}")
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
                self.hmModules.minimal
                ./hostconfig/ZeNixComputa/hm.nix
                ./hostconfig/ZeNixComputa/extra_info.nix
                self.hmModules.personal-cli
                self.hmModules.personal-gui
                self.hmModules.gaming
                inputs.fioul.homeManagerModules.default
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

      thinkpad-nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hostconfig/thinkpad-nixos/extra_info.nix
          ./hostconfig/thinkpad-nixos/nixos.nix
          ./hostconfig/thinkpad-nixos/hardware-configuration.nix
          self.nixosModules.minimal
          self.nixosModules.personal-cli
          self.nixosModules.personal-gui
          ({pkgs, ...}: {
            nixpkgs.overlays = [
              inputs.nur.overlay
              inputs.rust-overlay.overlays.default
              inputs.comma.overlays.default
              (final: prev: pkgList system prev.callPackage)
              (final: prev: inputs.nix-gaming.packages."${system}")
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
                ./hostconfig/thinkpad-nixos/extra_info.nix
                ./hostconfig/thinkpad-nixos/hm.nix
                self.hmModules.minimal
                self.hmModules.personal-cli
                self.hmModules.personal-gui
                inputs.fioul.homeManagerModules.default
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

    homeConfigurations."boyerq@thinkpad-nixos" = home-manager.lib.homeManagerConfiguration {
      modules = [
        self.hmModules.minimal
        self.hmModules.work
        self.hmModules.personal-cli
        self.hmModules.personal-gui
        inputs.fioul.homeManagerModules.default
        ./hostconfig/thinkpad-nixos/extra_info.nix
        ./hostconfig/thinkpad-nixos/hm.nix
      ];

      pkgs = import nixpkgs rec {
        system = "x86_64-linux";

        overlays = [
          inputs.nur.overlay
          inputs.rust-overlay.overlays.default
          inputs.comma.overlays.default
          (final: prev: pkgList system prev.callPackage)
          (final: prev: inputs.nix-gaming.packages."${system}")
        ];

        config.allowUnfree = true;
      };
    };
  };
}
