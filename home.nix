{ config
, pkgs
, lib
, ...
}:

let
  rustVersion = (pkgs.rustChannelOf { channel = "stable"; }).rust;
  rsPlatform = pkgs.makeRustPlatform {
    cargo = rustVersion;
    rustc = rustVersion;
  };
in
{
  home.sessionVariables = {
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
  };

  home.packages = with pkgs; [
    bitwarden-cli
    rustup
    nodePackages.vscode-json-languageserver
    exa
    python3
    topgrade
    wl-clipboard
    cargo-edit
    rsync
    fd
    niv
    bintools
    httpie
    sqlx-cli
    direnv
    codespell
    ripgrep
    file
    jq
    wget
    cargo-flamegraph
    linuxPackages.perf
    unzip
  ];

  services = {
    syncthing = {
      enable = true;
    };
  };

  programs = {
    home-manager = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    bat = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "Quentin Boyer";
      userEmail = config.extraInfo.email;
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          syntax-theme = "Dracula";
          plus-style = "auto \"#121bce\"";
          plus-emph-style = "auto \"#6083eb\"";
        };
      };
      extraConfig = {
        diff = {
          algorithm = "histogram";
        };
        core = {
          excludesfile = "${config.home.homeDirectory}/.gitignore";
        };
      };
    };

    zoxide = {
      enable = true;
    };
  };
  home.file = {
    ".gitignore".source = ./gitignore;
    "bin" = {
      source = ./scripts;
      recursive = true;
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
