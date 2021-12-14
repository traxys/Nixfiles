{
  description = "NixOS configuration";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager.url = "github:nix-community/home-manager";
      neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
      nixpkgs-mozilla = {
        url = "github:mozilla/nixpkgs-mozilla";
        flake = false;
      };
      dotacat = {
        url = "git+https://gitlab.scd31.com/stephen/dotacat.git";
        flake = false;
      };
      rnix-lsp.url = "github:nix-community/rnix-lsp";
      stylua = {
        url = "github:johnnymorganz/stylua";
        flake = false;
      };
      naersk.url = "github:nix-community/naersk";
      fast-syntax-highlighting = {
        url = "github:z-shell/fast-syntax-highlighting";
        flake = false;
      };
      zsh-nix-shell = {
        url = "github:chisui/zsh-nix-shell";
        flake = false;
      };
      nix-zsh-completions = {
        url = "github:spwhitt/nix-zsh-completions";
        flake = false;
      };
      powerlevel10k = {
        url = "github:romkatv/powerlevel10k";
        flake = false;
      };
      "plantuml-syntax" = {
        url = "github:aklt/plantuml-syntax";
        flake = false;
      };
      "nvim-web-devicons" = {
        url = "github:kyazdani42/nvim-web-devicons";
        flake = false;
      };
      "nvim-treesitter" = {
        url = "github:nvim-treesitter/nvim-treesitter";
        flake = false;
      };
      "nvim-lspconfig" = {
        url = "github:neovim/nvim-lspconfig";
        flake = false;
      };
      "lsp-status.nvim" = {
        url = "github:nvim-lua/lsp-status.nvim";
        flake = false;
      };
      "nvim-lightbulb" = {
        url = "github:kosayoda/nvim-lightbulb";
        flake = false;
      };
      "indentLine" = {
        url = "github:Yggdroot/indentLine";
        flake = false;
      };
      "gitsigns.nvim" = {
        url = "github:lewis6991/gitsigns.nvim";
        flake = false;
      };
      "plenary.nvim" = {
        url = "github:nvim-lua/plenary.nvim";
        flake = false;
      };
      "vim-moonfly-colors" = {
        url = "github:bluz71/vim-moonfly-colors";
        flake = false;
      };
      "vim-vsnip" = {
        url = "github:hrsh7th/vim-vsnip";
        flake = false;
      };
      "cmp-nvim-lsp" = {
        url = "github:hrsh7th/cmp-nvim-lsp";
        flake = false;
      };
      "cmp-buffer" = {
        url = "github:hrsh7th/cmp-buffer";
        flake = false;
      };
      "cmp-calc" = {
        url = "github:hrsh7th/cmp-calc";
        flake = false;
      };
      "cmp-path" = {
        url = "github:hrsh7th/cmp-path";
        flake = false;
      };
      "cmp-latex-symbols" = {
        url = "github:kdheepak/cmp-latex-symbols";
        flake = false;
      };
      "nvim-cmp" = {
        url = "github:hrsh7th/nvim-cmp";
        flake = false;
      };
      "vim-Grammalecte" = {
        url = "github:dpelle/vim-Grammalecte";
        flake = false;
      };
      "vim-LanguageTool" = {
        url = "github:dpelle/vim-LanguageTool";
        flake = false;
      };
      "lsp_extensions.nvim" = {
        url = "github:nvim-lua/lsp_extensions.nvim";
        flake = false;
      };
      "lsp_signature.nvim" = {
        url = "github:ray-x/lsp_signature.nvim";
        flake = false;
      };
      "telescope.nvim" = {
        url = "github:nvim-telescope/telescope.nvim";
        flake = false;
      };
      "popup.nvim" = {
        url = "github:nvim-lua/popup.nvim";
        flake = false;
      };
      "galaxyline.nvim" = {
        url = "github:NTBBloodbath/galaxyline.nvim";
        flake = false;
      };
      "vim-headerguard" = {
        url = "github:drmikehenry/vim-headerguard";
        flake = false;
      };
      "vim-matchup" = {
        url = "github:andymass/vim-matchup";
        flake = false;
      };
      "kommentary" = {
        url = "github:b3nj5m1n/kommentary";
        flake = false;
      };
      "lspkind-nvim" = {
        url = "github:onsails/lspkind-nvim";
        flake = false;
      };
      "editorconfig-vim" = {
        url = "github:editorconfig/editorconfig-vim";
        flake = false;
      };
      "null-ls.nvim" = {
        url = "github:jose-elias-alvarez/null-ls.nvim";
        flake = false;
      };
      "filetype.nvim" = {
        url = "github:nathom/filetype.nvim";
        flake = false;
      };
      "startuptime.vim" = {
        url = "github:tweekmonster/startuptime.vim";
        flake = false;
      };
    };

  outputs = { home-manager, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      ZeNixLaptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              inputs.neovim-nightly-overlay.overlay
              (import inputs.nixpkgs-mozilla)
            ];
          })
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.traxys = import ./home.nix;
            home-manager.extraSpecialArgs = {
              dotacat = inputs.dotacat;
              rnix-lsp = inputs.rnix-lsp;
              stylua = inputs.stylua;
              naersk-lib = inputs.naersk.lib."${system}";
              fast-syntax-highlighting = inputs.fast-syntax-highlighting;
              zsh-nix-shell = inputs.zsh-nix-shell;
              nix-zsh-completions = inputs.nix-zsh-completions;
              powerlevel10k = inputs.powerlevel10k;
              nvim-plugins = [
                {
                  name = "plantuml-syntax";
                  path = inputs."plantuml-syntax";
                }
                {
                  name = "nvim-web-devicons";
                  path = inputs."nvim-web-devicons";
                }
                {
                  name = "nvim-treesitter";
                  path = inputs."nvim-treesitter";
                }
                {
                  name = "nvim-lspconfig";
                  path = inputs."nvim-lspconfig";
                }
                {
                  name = "lsp-status.nvim";
                  path = inputs."lsp-status.nvim";
                }
                {
                  name = "nvim-lightbulb";
                  path = inputs."nvim-lightbulb";
                }
                {
                  name = "indentLine";
                  path = inputs."indentLine";
                }
                {
                  name = "gitsigns.nvim";
                  path = inputs."gitsigns.nvim";
                }
                {
                  name = "plenary.nvim";
                  path = inputs."plenary.nvim";
                }
                {
                  name = "vim-moonfly-colors";
                  path = inputs."vim-moonfly-colors";
                }
                {
                  name = "vim-vsnip";
                  path = inputs."vim-vsnip";
                }
                {
                  name = "cmp-nvim-lsp";
                  path = inputs."cmp-nvim-lsp";
                }
                {
                  name = "cmp-buffer";
                  path = inputs."cmp-buffer";
                }
                {
                  name = "cmp-calc";
                  path = inputs."cmp-calc";
                }
                {
                  name = "cmp-path";
                  path = inputs."cmp-path";
                }
                {
                  name = "cmp-latex-symbols";
                  path = inputs."cmp-latex-symbols";
                }
                {
                  name = "nvim-cmp";
                  path = inputs."nvim-cmp";
                }
                {
                  name = "vim-Grammalecte";
                  path = inputs."vim-Grammalecte";
                }
                {
                  name = "vim-LanguageTool";
                  path = inputs."vim-LanguageTool";
                }
                {
                  name = "lsp_extensions.nvim";
                  path = inputs."lsp_extensions.nvim";
                }
                {
                  name = "lsp_signature.nvim";
                  path = inputs."lsp_signature.nvim";
                }
                {
                  name = "telescope.nvim";
                  path = inputs."telescope.nvim";
                }
                {
                  name = "popup.nvim";
                  path = inputs."popup.nvim";
                }
                {
                  name = "galaxyline.nvim";
                  path = inputs."galaxyline.nvim";
                }
                {
                  name = "vim-headerguard";
                  path = inputs."vim-headerguard";
                }
                {
                  name = "vim-matchup";
                  path = inputs."vim-matchup";
                }
                {
                  name = "kommentary";
                  path = inputs."kommentary";
                }
                {
                  name = "lspkind-nvim";
                  path = inputs."lspkind-nvim";
                }
                {
                  name = "editorconfig-vim";
                  path = inputs."editorconfig-vim";
                }
                {
                  name = "null-ls.nvim";
                  path = inputs."null-ls.nvim";
                }
                {
                  name = "filetype.nvim";
                  path = inputs."filetype.nvim";
                }
                {
                  name = "startuptime.vim";
                  path = inputs."startuptime.vim";
                }
              ];
            };
            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
