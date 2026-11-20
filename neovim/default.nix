{
  inputs,
  self,
  lib,
  ...
}:
{
  imports = [
    inputs.nixvim.flakeModules.default
  ];

  nixvim = {
    packages.enable = true;
    checks.enable = true;
  };

  flake.nixvimModules = {
    config = import ./config {
      flake = self;
    };
    plugins = import ./plugins {
      inherit (inputs) vim-headerguard;
      fcitx = inputs."fcitx.nvim";
    };
    modules = lib.modules.importApply ./modules { inherit (inputs) tree-sitter-vvk; };

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
      pkgs,
      ...
    }:
    {
      nixvimConfigurations = {
        neovimTraxys = inputs.nixvim.lib.evalNixvim {
          inherit system;
          modules = [
            { nixpkgs.pkgs = pkgs; }
            self.nixvimModules.neovimTraxys
          ];
        };
      };
    };
}
