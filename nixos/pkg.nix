{
  config,
  pkgs,
  lib,
  ...
}: let
  ashmem = config.boot.kernelPackages.callPackage ./anbox.nix {name = "ashmem";};
  binder = config.boot.kernelPackages.callPackage ./anbox.nix {name = "binder";};
in {
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

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
