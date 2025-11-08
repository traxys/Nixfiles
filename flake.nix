{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gsm.url = "github:traxys/git-series-manager";
    niri.url = "github:sodiboo/niri-flake";
    nixgl.url = "github:nix-community/nixGL";

    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-root.url = "github:srid/flake-root";

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
    mujmap = {
      url = "github:elizagamedev/mujmap";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    fioul.url = "github:traxys/fioul";

    nixvim = {
      url = "github:nix-community/nixvim";
      #url = "/home/traxys/Documents/nixvim";
      #url = "github:traxys/nixvim?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    "vim-headerguard" = {
      url = "github:drmikehenry/vim-headerguard";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
      {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        debug = true;

        imports = [
          ./pkgs
          ./hostconfig
          ./templates
          ./neovim
          inputs.treefmt-nix.flakeModule
          inputs.flake-root.flakeModule
        ];

        perSystem =
          {
            inputs',
            lib,
            system,
            config,
            ...
          }:
          {
            _module.args = {
              naersk' = inputs.naersk.lib.${system};
              pkgs = import inputs.nixpkgs {
                inherit system;
                config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "warcraftlogs" ];
              };
            };
            packages =
              let
                names = [
                  "glaurung"
                  "raclette"
                  "mujmap"
                ];
              in
              lib.genAttrs names (name: inputs'.${name}.packages.${name});

            formatter = config.treefmt.build.wrapper;

            treefmt.config = {
              inherit (config.flake-root) projectRootFile;

              programs = {
                nixfmt-rfc-style.enable = true;
                statix.enable = true;
              };
            };
          };

        flake =
          let
            extraInfo = import ./extra_info.nix;
          in
          {
            hmModules = {
              minimal = import ./minimal/hm.nix {
                inherit inputs extraInfo;
                flake = self;
              };
              personal-cli = import ./personal-cli/hm.nix;
              gui = import ./gui/hm.nix {
                wayland-pipewire-idle-inhibit = inputs.wayland-pipewire-idle-inhibit.homeModules.default;
              };
              wm = import ./wm/hm.nix {
                inherit (inputs) niri;
              };
              de = import ./de/hm.nix;
              personal-gui = import ./personal-gui/hm.nix;
              gaming = import ./gaming/hm.nix;
              work = import ./hostconfig/thinkpad-nixos/work.nix;
            };

            nixosModules = {
              minimal = import ./minimal/nixos.nix { inherit extraInfo; };
              personal-cli = import ./personal-cli/nixos.nix;
              gui = import ./gui/nixos.nix;
              wm = import ./wm/nixos.nix { inherit (inputs) niri; };
              de = import ./de/nixos.nix;
              personal-gui = import ./personal-gui/nixos.nix;
              roaming = import ./roaming/nixos.nix;
              gaming = import ./gaming/nixos.nix;
            };
          };
      }
    );
}
