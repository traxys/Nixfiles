{ config
, pkgs
, lib
, dotacat
, stylua
, naersk-lib
, fast-syntax-highlighting
, zsh-nix-shell
, nix-zsh-completions
, powerlevel10k
, nvim-plugins
, ...
}:

let
  rustVersion = (pkgs.rustChannelOf { channel = "stable"; }).rust;
  rsPlatform = pkgs.makeRustPlatform {
    cargo = rustVersion;
    rustc = rustVersion;
  };
  plugin_path = ".local/share/nvim/site/pack/nix/start/";
  plugin-files = builtins.listToAttrs (map
    ({ name, path }: {
      name = "${plugin_path}/${name}";
      value = {
        source = path;
        recursive = true;
      };
    })
    nvim-plugins);
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
    neovim-nightly
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
      pname = "dotacat";
      root = dotacat;
    })
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

    zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "wd" "rust" ];
      };
      plugins = [
        {
          name = "fast-syntax-highlighting";
          file = "fast-syntax-highlighting.plugin.zsh";
          src = fast-syntax-highlighting;
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = zsh-nix-shell;
        }
        {
          name = "nix-zsh-completions";
          file = "nix-zsh-completions.plugin.zsh ";
          src = nix-zsh-completions;
        }
      ];
      initExtra =
        ''
          export PATH="$PATH:${localinfo.homeDir}/bin"
          source ~/.p10k.zsh
          source ~/.powerlevel10k/powerlevel10k.zsh-theme
          eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
          if [ -f "$HOME/.zvars" ]; then
            source "$HOME/.zvars"
          fi
          ${pkgs.fortune}/bin/fortune \
            | ${pkgs.cowsay}/bin/cowsay \
            | dotacat
        '';
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat -p";
        ls = "${pkgs.exa}/bin/exa --icons";
        screenRegion = "${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - ";
        py3 = "nix-shell -p python3 python3.pkgs.matplotlib --run python3";
        ssh = "kitty +kitten ssh";
        ns = "nix-shell";
      };
    };
  };
  home.file = {
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    ".powerlevel10k" = {
      source = powerlevel10k;
    };
    ".zprofile".source = ./zprofile;
    ".p10k.zsh".source = ./p10k.zsh;
    ".gitignore".source = ./gitignore;
    "bin" = {
      source = ./scripts;
      recursive = true;
    };
  } // plugin-files;

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
