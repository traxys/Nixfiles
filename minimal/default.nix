{
  inputs,
  flake,
}: {
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.git.excludes = lib.mkOption {
    type = lib.types.lines;
    default = "";
  };

  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  config = {
    home.packages = with pkgs; [
      bat
      comma
      fd
      file
      gdb
      gnumake
      jq
      man-pages
      neovimTraxys
      nix-zsh-completions
      oscclip
      pandoc
      raclette
      ripgrep
      rsync
      tokei
      unzip
      wget

      # Useful for pandoc to latex
      (texlive.combine {
        inherit
          (texlive)
          scheme-medium
          fncychap
          wrapfig
          capt-of
          framed
          upquote
          needspace
          tabulary
          varwidth
          titlesec
          ;
      })
    ];

    nix.registry = {
      "my".flake = flake;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    programs.home-manager.enable = true;
    programs.bat.enable = true;
    programs.zoxide.enable = true;

    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      delta = {
        enable = true;
        options = {
          line-numbers = true;
          syntax-theme = "Dracula";
          plus-style = "auto \"#121bce\"";
          plus-emph-style = "auto \"#6083eb\"";
        };
      };

      excludes = ''
        .cache
        compile_commands.json
      '';

      extraConfig = {
        diff = {
          algorithm = "histogram";
        };
        core = {
          excludesfile = "${pkgs.writeText "gitignore" config.programs.git.excludes}";
        };
      };

      aliases = {
        ri = "rebase -i";
        amend = "commit --amend";
      };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "wd" "rust"];
      };
      plugins = [
        {
          name = "fast-syntax-highlighting";
          file = "fast-syntax-highlighting.plugin.zsh";
          src = inputs.fast-syntax-highlighting;
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = inputs.zsh-nix-shell;
        }
      ];

      envExtra = "export EDITOR=nvim";

      initExtra = ''
        export PATH="$PATH:$HOME/bin";
        source ${./p10k.zsh}
        source ${inputs.powerlevel10k}/powerlevel10k.zsh-theme
        if [ -f "$HOME/.zvars" ]; then
        	source "$HOME/.zvars"
        fi

        ${pkgs.fortune}/bin/fortune \
          | ${pkgs.cowsay}/bin/cowsay \
          | ${pkgs.dotacat}/bin/dotacat
      '';
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat -p";
        ls = "${pkgs.exa}/bin/exa --icons";
      };
    };

    home.file = {
      ".zprofile".source = ./zprofile;
    };

    home.stateVersion = "21.11";
  };
}
