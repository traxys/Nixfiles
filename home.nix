{ config
, pkgs
, lib
, stylua
, naersk-lib
, ...
}:

let
  rustVersion = (pkgs.rustChannelOf { channel = "stable"; }).rust;
  rsPlatform = pkgs.makeRustPlatform {
    cargo = rustVersion;
    rustc = rustVersion;
  };
  localinfo = import ./localinfo.nix;
in
{
  imports = [
    ./graphical.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = localinfo.username;
  home.homeDirectory = localinfo.homeDir;

  home.sessionVariables = {
    EDITOR = "nvim";
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
  };

  home.packages = with pkgs; [
    bitwarden-cli
    rustup
    neovimTraxys
    rust-analyzer
    clang-tools
    nodePackages.vscode-json-languageserver
    nodePackages.bash-language-server
    nixpkgs-fmt
    rnix-lsp
    exa
    python3
    topgrade
    wl-clipboard
    (naersk-lib.buildPackage {
      pname = "stylua";
      root = stylua;
    })
    cargo-edit
    rsync
    fd
    niv
    bintools
    httpie
    sqlx-cli
    direnv
    codespell
    shellcheck
    ripgrep
    file
    jq
    wget
    cargo-flamegraph
    linuxPackages_latest.perf
    unzip
  ];

  services = {
    syncthing = {
      enable = true;
      tray = {
        enable = true;
      };
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
      userEmail = localinfo.email;
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
          excludesfile = "${localinfo.homeDir}/.gitignore";
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
