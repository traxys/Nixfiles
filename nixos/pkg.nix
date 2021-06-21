{ config, pkgs, ... }:

{
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  nixpkgs.config = {
    package = pkgs.nixFlakes;
    allowUnfree = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    neovim-nightly
    git
    gnumake
    ripgrep
    flashrom
    gcc
    libappindicator
    file
    jq
  ];
}

