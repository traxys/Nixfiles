{ inputs, self, ... }:
{
  perSystem =
    {
      inputs',
      self',
      pkgs,
      system,
      ...
    }:
    {
      packages = {
        neovimTraxys = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
          module = {
            imports = [ ./default.nix ];
          };
          extraSpecialArgs = {
            flake = self;
          };
          pkgs = pkgs.extend (
            final: prev:
            {
              inherit (inputs'.nixpkgs-staging.legacyPackages) tree-sitter;
              vimPlugins = prev.vimPlugins.extend (
                final': prev': {
                  vim-headerguard = prev.vimUtils.buildVimPlugin {
                    pname = "vim-headerguard";
                    src = inputs.vim-headerguard;
                    version = inputs.vim-headerguard.shortRev;
                  };
                  wiki-vim = prev.vimUtils.buildVimPlugin {
                    pname = "wiki.vim";
                    src = inputs."wiki.vim";
                    version = inputs."wiki.vim".shortRev;

                    dependencies = with prev'; [
                      plenary-nvim
                      telescope-nvim
                    ];
                  };
                  diagram-nvim = prev.vimUtils.buildVimPlugin {
                    pname = "diagram.nvim";
                    src = inputs."diagram.nvim";
                    version = inputs."diagram.nvim".shortRev;

                    dependencies = with prev'; [ image-nvim ];
                  };

                  nvim-cmp = final'.blink-compat;
                }
              );
            }
            // self'.packages
          );
        };
      };

      checks.launch-neovim = inputs.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
        nvim = self'.packages.neovimTraxys.extend (
          { lib, ... }:
          {
            test.checkWarnings = false;
            plugins.image.enable = lib.mkForce false;
            plugins.diagram-nvim.enable = lib.mkForce false;
          }
        );
        name = "Neovim configuration";
      };
    };
}
