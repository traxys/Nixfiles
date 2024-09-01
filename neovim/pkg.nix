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
                  };
                  diagram-nvim = prev.vimUtils.buildVimPlugin {
                    pname = "diagram.nvim";
                    src = inputs."diagram.nvim";
                    version = inputs."diagram.nvim".shortRev;
                  };
                }
              );
            }
            // self'.packages
          );
        };
      };

      checks.launch = inputs.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
        nvim = self'.packages.neovimTraxys.extend { test.checkWarnings = false; };
        name = "Neovim configuration";
      };
    };
}
