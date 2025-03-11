{ inputs, self, ... }:
{
  imports = [
    inputs.nixvim.flakeModules.default
  ];

  nixvim = {
    packages.enable = true;
    checks.enable = true;
  };

  flake.nixvimModules = {
    config = import ./config { flake = self; };
    plugins = import ./plugins {
      inherit (inputs) vim-headerguard;
    };
    modules = ./modules;

    neovimTraxys = {
      imports = [
        self.nixvimModules.config
        self.nixvimModules.plugins
        self.nixvimModules.modules
        {
          nixpkgs.overlays = [
            (final: prev: {
            })
          ];
        }
      ];
    };
  };

  perSystem =
    {
      system,
      ...
    }:
    {
      nixvimConfigurations = {
        neovimTraxys = inputs.nixvim.lib.evalNixvim {
          inherit system;
          modules = [
            self.nixvimModules.neovimTraxys
          ];
        };
      };
    };
}
