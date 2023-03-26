{
  config,
  pkgs,
  lib,
  ...
}: let
  ashmem = config.boot.kernelPackages.callPackage ./anbox.nix {name = "ashmem";};
  binder = config.boot.kernelPackages.callPackage ./anbox.nix {name = "binder";};
in {
  # boot.extraModulePackages = [ ashmem binder ];
  # boot.kernelModules = [ "ashmem_linux" "binder_linux" ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  /*
   nixpkgs.config.packageOverrides = pkgs: {
  steam = pkgs.steam.override {
  nativeOnly = true;
  };
  };
  */

  programs.steam.enable = true;
}
