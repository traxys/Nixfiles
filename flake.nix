{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs-traxys.url = "github:traxys/nixpkgs/inflight";
    nixpkgs-sunshine.url = "github:devusb/nixpkgs?ref=sunshine-module";
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
    gsm.url = "github:traxys/git-series-manager";
    attic.url = "github:zhaofengli/attic";

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

    neovim-flake = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      #url = "/home/traxys/Documents/nixvim";
      #url = "github:traxys/nixvim?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim plugins
    "plugin:clangd_extensions-nvim" = {
      url = "github:p00f/clangd_extensions.nvim";
      flake = false;
    };
    "plugin:netman-nvim" = {
      url = "github:miversen33/netman.nvim";
      flake = false;
    };
    "plugin:cmp-buffer" = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    "plugin:cmp-calc" = {
      url = "github:hrsh7th/cmp-calc";
      flake = false;
    };
    "plugin:cmp-nvim-lsp" = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    "plugin:cmp-path" = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    "plugin:cmp_luasnip" = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    "plugin:comment-nvim" = {
      url = "github:numtostr/comment.nvim";
      flake = false;
    };
    "plugin:firenvim" = {
      url = "github:glacambre/firenvim";
      flake = false;
    };
    "plugin:git-messenger-vim" = {
      url = "github:rhysd/git-messenger.vim";
      flake = false;
    };
    "plugin:gitsigns-nvim" = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    "plugin:inc-rename-nvim" = {
      url = "github:smjonas/inc-rename.nvim";
      flake = false;
    };
    "plugin:indent-blankline-nvim" = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    "plugin:lspkind-nvim" = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };
    "plugin:lualine-nvim" = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    "plugin:noice-nvim" = {
      url = "github:folke/noice.nvim";
      flake = false;
    };
    "plugin:nui-nvim" = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    "plugin:nvim-cmp" = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    "plugin:nvim-lightbulb" = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };
    "plugin:nvim-lspconfig" = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    "plugin:nvim-notify" = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };
    "plugin:nvim-osc52" = {
      url = "github:ojroques/nvim-osc52";
      flake = false;
    };
    "plugin:nvim-tree-lua" = {
      url = "github:nvim-tree/nvim-tree.lua";
      flake = false;
    };
    "plugin:nvim-treesitter-context" = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };
    "plugin:nvim-treesitter-refactor" = {
      url = "github:nvim-treesitter/nvim-treesitter-refactor";
      flake = false;
    };
    "plugin:plantuml-syntax" = {
      url = "github:aklt/plantuml-syntax";
      flake = false;
    };
    "plugin:plenary-nvim" = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    "plugin:rustaceanvim" = {
      url = "github:mrcjkb/rustaceanvim";
      flake = false;
    };
    "plugin:telescope-nvim" = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    "plugin:telescope-ui-select-nvim" = {
      url = "github:nvim-telescope/telescope-ui-select.nvim";
      flake = false;
    };
    "plugin:trouble-nvim" = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };
    "plugin:vim-matchup" = {
      url = "github:andymass/vim-matchup";
      flake = false;
    };
    "plugin:luasnip" = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    "plugin:nvim-treesitter" = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    "plugin:openscad-nvim" = {
      url = "github:salkin-mada/openscad.nvim";
      flake = false;
    };
    "plugin:neo-tree-nvim" = {
      url = "github:nvim-neo-tree/neo-tree.nvim";
      flake = false;
    };
    "plugin:nvim-web-devicons" = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    "plugin:popup-nvim" = {
      url = "github:nvim-lua/popup.nvim";
      flake = false;
    };
    "plugin:skim-vim" = {
      url = "github:lotabout/skim.vim";
      flake = false;
    };
    "plugin:tokyonight-nvim" = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    "plugin:vim-snippets" = {
      url = "github:honza/vim-snippets";
      flake = false;
    };
    "plugin:markdown-preview-nvim" = {
      url = "github:iamcco/markdown-preview.nvim";
      flake = false;
    };
    "plugin:which-key-nvim" = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    "plugin:zk-nvim" = {
      url = "github:mickael-menu/zk-nvim";
      flake = false;
    };
    "plugin:efmls-configs-nvim" = {
      url = "github:creativenull/efmls-configs-nvim";
      flake = false;
    };
    "plugin:vim-just" = {
      url = "github:NoahTheDuke/vim-just/";
      flake = false;
    };
    "plugin:ltex_extra-nvim" = {
      url = "github:barreiroleo/ltex_extra.nvim";
      flake = false;
    };

    # Plugins that are not in nixpkgs
    "new-plugin:vim-headerguard" = {
      url = "github:drmikehenry/vim-headerguard";
      flake = false;
    };
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

    pkgList = system: callPackage: let
      packages =
        (import ./pkgs/default.nix {
          inherit callPackage;
          sources = sources system;
          naersk = inputs.naersk.lib."${system}";
        })
        // {
          glaurung = inputs.glaurung.defaultPackage."${system}";
          raclette = inputs.raclette.defaultPackage."${system}";
          roaming_proxy = inputs.roaming_proxy.defaultPackage."${system}";

          inherit (nixpkgs-traxys.legacyPackages."${system}") groovy-language-server;
          inherit (inputs.mujmap.packages."${system}") mujmap;
          inherit (inputs.attic.packages."${system}") attic;
        };
    in
      packages
      // (
        let
          inputsMatching = with builtins;
            prefix:
              nixpkgs.lib.mapAttrs'
              (prefixedName: value: {
                name =
                  substring (stringLength "${prefix}:") (stringLength prefixedName) prefixedName;
                inherit value;
              })
              (nixpkgs.lib.filterAttrs
                (name: _: (match "${prefix}:.*" name) != null)
                inputs);

          neovimPlugins = final: prev:
            {
              vimPlugins = prev.vimPlugins.extend (final': prev':
                (nixpkgs.lib.mapAttrs (
                  pname: src:
                    prev'."${pname}".overrideAttrs (old: {
                      version = src.shortRev;
                      inherit src;
                    })
                ) (inputsMatching "plugin"))
                // (
                  nixpkgs.lib.mapAttrs (
                    pname: src:
                      prev.vimUtils.buildVimPlugin {
                        inherit pname src;
                        version = src.shortRev;
                      }
                  ) (inputsMatching "new-plugin")
                ));
            }
            // packages;

          nixvim' = inputs.nixvim.legacyPackages."${system}";
          neovimNightly = inputs.neovim-flake.packages."${system}".neovim;
        in {
          inherit
            (callPackage ({pkgs}: let
              neovimPkgs = (pkgs.extend neovimPlugins).extend (final: prev: {
                vimPlugins = prev.vimPlugins.extend (final': prev': {
                  nvim-treesitter = prev'.nvim-treesitter.overrideAttrs (
                    prev.callPackage ./neovim/nvim-treesitter/override.nix {} final' prev'
                  );
                });
              });
            in {
              neovimTraxys = nixvim'.makeNixvimWithModule {
                module = {
                  imports = [./neovim];
                  package = neovimNightly;
                };
                pkgs = neovimPkgs;
              };
              update-nvim-treesitter = neovimPkgs.callPackage ./neovim/nvim-treesitter {
                upstream = neovimNightly;
              };
            }) {})
            neovimTraxys
            update-nvim-treesitter
            ;
        }
      );

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
    checks.x86_64-linux.launch = inputs.nixvim.lib.x86_64-linux.check.mkTestDerivationFromNvim {
      nvim = self.packages.x86_64-linux.neovimTraxys;
      name = "Neovim configuration";
    };
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
          ./hostconfig/ZeNixLaptop/extra_info.nix
          ./hostconfig/ZeNixLaptop/nixos.nix
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
                ./hostconfig/ZeNixLaptop/extra_info.nix
                ./hostconfig/ZeNixLaptop/hm.nix
                self.hmModules.minimal
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

      ZeNixComputa = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit (inputs) nixpkgs-sunshine;
        };
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

      minus = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hostconfig/minus/extra_info.nix
          ./hostconfig/minus/hardware-configuration.nix
          ./hostconfig/minus/nixos.nix
          self.nixosModules.minimal
          self.nixosModules.personal-cli
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
          ({config, ...}: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${config.extraInfo.username} = {
              config,
              lib,
              pkgs,
              ...
            }: {
              imports = [
                ./hostconfig/minus/extra_info.nix
                ./hostconfig/minus/hm.nix
                self.hmModules.minimal
                self.hmModules.personal-cli
                inputs.fioul.homeManagerModules.default
              ];
            };
            home-manager.extraSpecialArgs = {
              flake = self;
            };
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          })
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
        inputs.gsm.homeManagerModules.default
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
