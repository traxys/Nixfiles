{
  config,
  pkgs,
  lib,
  flake,
  ...
}: let
  rustVersion = (pkgs.rustChannelOf {channel = "stable";}).rust;
  rsPlatform = pkgs.makeRustPlatform {
    cargo = rustVersion;
    rustc = rustVersion;
  };
in {
  home.packages = with pkgs; [
    nodePackages.vscode-json-languageserver
    exa
    python3
    topgrade
    niv
    bintools
    httpie
    sqlx-cli
    codespell
    cargo-flamegraph
    linuxPackages.perf
    gcc11
    bc
  ];

  programs = {
    starship = {
      enable = true;
    };

    ssh = {
      enable = true;
      matchBlocks = {
      };
    };
  };

  programs.zsh = {
    shellAliases = {
      new-direnv = "nix flake new -t github:nix-community/nix-direnv";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
