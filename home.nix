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
    neovimTraxys
    bitwarden-cli
    nodePackages.vscode-json-languageserver
    exa
    python3
    topgrade
    rsync
    fd
    niv
    bintools
    httpie
    sqlx-cli
    codespell
    ripgrep
    file
    jq
    wget
    cargo-flamegraph
    linuxPackages.perf
    unzip
    tokei
    gcc11
    #nix-alien
    xdg-ninja
    bc
    kabalist_cli
    comma
    raclette
    oscclip
    nvfetcher
    hbw
  ];

  services = {
    syncthing = {
      enable = true;
    };
  };

  nix.registry = {
    "my".flake = flake;
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    home-manager = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    bat = {
      enable = true;
    };

    zoxide = {
      enable = true;
    };

    ssh = {
      enable = true;
      matchBlocks = {
      };
    };
  };
  home.file = {
    "bin" = {
      source = ./scripts;
      recursive = true;
    };
    "bin/ssh-picker" = let
      ssh_hosts = builtins.attrNames config.programs.ssh.matchBlocks;
      ssh_specific = builtins.filter (h: !(lib.strings.hasInfix "*" h)) ssh_hosts;
      ssh_specific_echo = builtins.map (h: "echo ${h}") ssh_specific;

      picker =
        if config.wm.kind == "sway"
        then "${pkgs.wofi}/bin/wofi -S dmenu"
        else "${pkgs.rofi}/bin/rofi -dmenu";
    in {
      text = ''
        #!/usr/bin/env bash

        {
            ${lib.strings.concatStringsSep "\n" ssh_specific_echo}
        } | ${picker} | xargs ${config.terminal.command} ssh
      '';
      executable = true;
    };
    ".zfunc" = {
      source = ./zfunc;
      recursive = true;
    };
  };

  programs.zsh = {
    initExtraBeforeCompInit = ''
      fpath+="$HOME/.zfunc"
    '';
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
