{
  inputs,
  flake,
  extraInfo,
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
    extraInfo
  ];

  config = {
    home.sessionVariables = rec {
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      CARGO_HOME = "${XDG_DATA_HOME}/cargo";
      DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";
      GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
      XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
      NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
      NUGET_PACKAGES = "${XDG_CACHE_HOME}/NuGetPackages";
      PSQL_HISTORY = "${XDG_DATA_HOME}/psql_history";
      PYTHONSTARTUP = "${XDG_CONFIG_HOME}/python/pythonrc";
      RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
      WINEPREFIX = "${XDG_DATA_HOME}/wine";
    };

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
      frg
      nix-output-monitor

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
    programs.bat = {
      enable = true;
      syntaxes = {
        meson = {
          src = inputs.meson-syntax;
          file = "meson.sublime-syntax";
        };
      };
    };
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

        if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
           SESSION_TYPE=remote/ssh
        else
          case $(ps -o comm= -p "$PPID") in
            sshd|*/sshd) SESSION_TYPE=remote/ssh;;
          esac
        fi

        if [[ $SESSION_TYPE = remote/ssh ]]; then
          title_prefix="$(whoami)@$(hostname) - "
        fi

        DISABLE_AUTO_TITLE="true"

        preexec() {
          cmd=$1
          if [[ -n $cmd ]]; then
            print -Pn "\e]0;$title_prefix$cmd\a"
          fi
        }

        precmd() {
          dir=$(pwd | sed "s:$HOME:~:")
          print -Pn "\e]0;$(whoami)@$(hostname):$dir\a"
        }

        zmodload zsh/zpty

        ${pkgs.fortune}/bin/fortune \
          | ${pkgs.cowsay}/bin/cowsay \
          | ${pkgs.dotacat}/bin/dotacat
      '';
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat -p";
        ls = "${pkgs.eza}/bin/eza --icons";
      };
    };

    home.file = {
      ".zprofile".source = ./zprofile;
      ".config/python/pythonrc".text = ''
        import os
        import atexit
        import readline

        history = os.path.join(os.environ['XDG_CACHE_HOME'], 'python_history')
        try:
          readline.read_history_file(history)
        except OSError:
          pass

        def write_history():
          try:
            readline.write_history_file(history)
          except OSError:
            pass

        atexit.register(write_history)
      '';
    };
  };
}
