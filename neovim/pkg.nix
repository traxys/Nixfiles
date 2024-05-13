{ inputs, lib, ... }:
let
  inputsMatching =
    prefix:
    lib.mapAttrs' (prefixedName: value: {
      name =
        builtins.substring (builtins.stringLength "${prefix}:") (builtins.stringLength prefixedName)
          prefixedName;
      inherit value;
    }) (lib.filterAttrs (name: _: (builtins.match "${prefix}:.*" name) != null) inputs);
in
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
      packages =
        let
          neovimPlugins =
            final: prev:
            {
              vimPlugins = prev.vimPlugins.extend (
                final': prev':
                (lib.mapAttrs (
                  pname: src:
                  prev'."${pname}".overrideAttrs (old: {
                    version = src.shortRev;
                    inherit src;
                  })
                ) (inputsMatching "plugin"))
                // (lib.mapAttrs (
                  pname: src:
                  prev.vimUtils.buildVimPlugin {
                    inherit pname src;
                    version = src.shortRev;
                  }
                ) (inputsMatching "new-plugin"))
                // {
                  nvim-treesitter = prev'.nvim-treesitter.overrideAttrs (
                    prev.callPackage ./nvim-treesitter/override.nix { } final' prev'
                  );
                }
              );
            }
            // self'.packages;
          neovimPkgs = pkgs.extend neovimPlugins;
        in
        {
          neovimTraxys = inputs'.nixvim.legacyPackages.makeNixvimWithModule {
            module = {
              imports = [ ./default.nix ];
              package = inputs'.neovim-flake.packages.neovim;
            };
            pkgs = neovimPkgs;
          };
          update-nvim-treesitter = neovimPkgs.callPackage ./nvim-treesitter {
            upstream = inputs'.neovim-flake.packages.neovim;
          };
        };

      checks.launch = inputs.nixvim.lib.${system}.check.mkTestDerivationFromNvim {
        nvim = self'.packages.neovimTraxys;
        name = "Neovim configuration";
      };
    };
}
