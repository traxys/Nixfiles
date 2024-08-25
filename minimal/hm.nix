{
  inputs,
  flake,
  extraInfo,
}:
{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.programs.git.excludes = lib.mkOption {
    type = lib.types.lines;
    default = "";
  };

  options.extraNixvim = lib.mkOption {
    type = lib.types.listOf lib.types.anything;
    default = [ ];
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

    home.packages =
      (with pkgs; [
        bat
        comma
        fd
        file
        gdb
        gnumake
        jq
        man-pages
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
        bat-extras.prettybat
        just
        bottom

        # Useful for pandoc to latex
        (texlive.combine {
          inherit (texlive)
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
      ])
      ++ [ (pkgs.neovimTraxys.extend { imports = config.extraNixvim; }) ];

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
      lfs.enable = true;
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
        .patches
        compile_commands.json
      '';

      extraConfig = {
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
        rebase = {
          autosquash = true;
          updateRefs = true;
        };
        branch.sort = "-committerdate";
        column.ui = "auto";
        diff = {
          algorithm = "histogram";
        };
        core = {
          excludesfile = "${pkgs.writeText "gitignore" config.programs.git.excludes}";
        };
      };

      aliases = {
        fpush = "push --force-with-lease";
        ri = "rebase -i";
        fix = "commit --fixup";
        amend = "commit --amend";
        rib = "!git ri $(git bb) $@";
        bb = "config --local --default master custom.base-branch";
        set-bb = "config --local custom.base-branch";
        rv = ''!sh -c 'git commit --amend --no-edit --trailer "Reviewed-by: $*"' - '';
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings =
        let
          background = "#3e3e3e";
        in
        {
          add_newline = true;

          format = lib.concatStrings [
            "["
            "[](${background})"
            "$os"
            " "
            "$directory"
            "$git_branch"
            "$git_status"
            "](bg:${background})"
            "[](${background})"
            "$fill"
            "[](${background})"
            "["
            " "
            "$status"
            "$cmd_duration"
            "($username$hostname  )"
            "$time"
            "](bg:${background})"
            "[](${background})"
            "\n"
            " $character"
          ];

          fill = {
            symbol = "·";
            style = background;
          };

          directory = {
            style = "bold cyan bg:${background}";
            read_only_style = "fg:red bg:${background}";
          };

          git_branch = {
            symbol = " ";
            format = " [$symbol$branch]($style) ";
            style = "bold purple bg:${background}";
          };

          git_status =
            let
              red = "#ee311a";
            in
            {
              format = "[$conflicted$stashed$staged$ahead_behind$deleted$renamed$modified$untracked]($style)";
              style = "bg:${background}";
              ahead = "[$count](green bg:${background}) ";
              behind = "[$count](green bg:${background}) ";
              stashed = "*$count ";
              renamed = "~$count ";
              staged = "+ ";
              untracked = "?$count ";
              diverged = "[$ahead_count$behind_count](green bg:${background}) ";
              conflicted = "[$count](${red} bg:${background}) ";
              modified = "!$count ";
              deleted = "[✘$count ](${red} bg:${background})";
            };

          os = {
            disabled = false;
            style = "bg:${background}";
            symbols = rec {
              NixOS = " ";
              Redhat = " ";
              RedHatEnterprise = Redhat;
              Fedora = " ";
            };
          };

          time = {
            disabled = false;
            style = "bold yellow bg:${background}";
            format = "$time ";
          };

          cmd_duration = {
            disabled = false;
            format = "[$duration ]($style)  ";
            style = "bold yellow bg:${background}";
          };

          username = {
            format = "[$user]($style)";
            style_root = "bold red bg:${background}";
            style_user = "bold dimmed green bg:${background}";
          };

          hostname = {
            ssh_only = true;
            format = "[@$hostname]($style)";
            style = "bold dimmed green bg:${background}";
          };

          status = {
            disabled = false;
            format = "[$symbol$status( $signal_name)]($style)  ";
            pipestatus_segment_format = "[$symbol$status]($style)";
            pipestatus_format = "\\[$pipestatus\\] [$symbol$signal_name]($style)  ";
            pipestatus_separator = " | ";
            style = "bold red bg:#3e3e3e";
            map_symbol = true;
            pipestatus = true;
            sigint_symbol = "";
          };
        };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "wd"
          "rust"
        ];
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
        {
          name = "jq-zsh-plugin";
          file = "jq.plugin.zsh";
          src = inputs.jq-zsh-plugin;
        }
      ];

      envExtra = "export EDITOR=nvim";

      initExtra = ''
        export PATH="$PATH:$HOME/bin";
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

        compdef batman=man

        zmodload zsh/zpty

        ${pkgs.fortune}/bin/fortune \
          | ${pkgs.cowsay}/bin/cowsay \
          | ${pkgs.dotacat}/bin/dotacat
      '';
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat -p";
        ls = "${pkgs.eza}/bin/eza --icons";
        man = "${lib.getExe pkgs.bat-extras.batman}";
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
