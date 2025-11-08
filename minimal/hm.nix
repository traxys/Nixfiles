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

  imports = [
    inputs.nix-index-database.homeModules.nix-index
    inputs.nixvim.homeModules.nixvim
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
      DELTA_PAGER = "less -+X";
      EDITOR = "nvim";
    };

    programs.nixvim = _: {
      enable = true;
      imports = [ flake.nixvimModules.neovimTraxys ];
    };

    home.packages = with pkgs; [
      bat
      comma
      fd
      sd
      choose
      file
      gdb
      gnumake
      jq
      man-pages
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
      keychain
      rclone
      nix-du

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
    ];

    nix.registry = {
      "my".flake = flake;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.tealdeer = {
      enable = true;
      settings.auto_update = true;
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

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        line-numbers = true;
        syntax-theme = "Dracula";
        plus-style = "auto \"#121bce\"";
        plus-emph-style = "auto \"#6083eb\"";
      };
    };

    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      lfs.enable = true;

      excludes = ''
        .cache
        .patches
        compile_commands.json
      '';

      settings = {
        sendemail = {
          composeEncoding = "utf-8";
        };
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
        feature = {
          manyFiles = true;
        };
        fetch = {
          writeCommitGraph = true;
        };
        core = {
          excludesfile = "${pkgs.writeText "gitignore" config.programs.git.excludes}";
          untrackedCache = true;
          commitGraph = true;
        };

        alias = {
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
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
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
            "$git_state"
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
            truncate_to_repo = false;
            fish_style_pwd_dir_length = 1;
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

          git_state = rec {
            style = "bold red bg:${background}";
            rebase = "";
            merge = "";
            revert = "󰜱";
            cherry_pick = "";
            bisect = "󰝔";
            am = "";
            am_or_rebase = "${am}/${rebase}";
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

    programs.fish = {
      enable = true;

      functions = {
        fish_greeting = ''
          ${pkgs.fortune}/bin/fortune \
            | ${pkgs.cowsay}/bin/cowsay \
            | ${pkgs.dotacat}/bin/dotacat
        '';
        fish_user_key_bindings = ''
          bind -k up up-or-search-prefix
          bind \eOA up-or-search-prefix
          bind \e\[A up-or-search-prefix
          bind -k down down-or-search-prefix
          bind \eOB down-or-search-prefix
          bind \e\[B down-or-search-prefix
        '';
        up-or-search-prefix = {
          description = "Search (by prefix) back or move cursor up 1 line";
          body = ''
            # If we are already in search mode, continue
            if commandline --search-mode
              commandline -f history-prefix-search-backward
              return
            end

            # If we are navigating the pager, then up always navigates
            if commandline --paging-mode
                commandline -f up-line
                return
            end

            # We are not already in search mode.
            # If we are on the top line, start search mode,
            # otherwise move up
            set -l lineno (commandline -L)

            switch $lineno
                case 1
                    commandline -f history-prefix-search-backward

                case '*'
                    commandline -f up-line
            end
          '';
        };
        down-or-search-prefix = {
          description = "Search (by prefix) forward or move down 1 line";
          body = ''
            # If we are already in search mode, continue
            if commandline --search-mode
                commandline -f history-prefix-search-forward
                return
            end

            # If we are navigating the pager, then up always navigates
            if commandline --paging-mode
                commandline -f down-line
                return
            end

            # We are not already in search mode.
            # If we are on the bottom line, start search mode,
            # otherwise move down
            set -l lineno (commandline -L)
            set -l line_count (count (commandline))

            switch $lineno
                case $line_count
                    commandline -f history-prefix-search-forward

                case '*'
                    commandline -f down-line
            end
          '';
        };
      };

      shellInit = ''
        if [ -f "$HOME/.zvars" ]
          source "$HOME/.zvars"
        end
      '';

      shellInitLast = ''
        # Use set -Ua SSH_KEYS_TO_AUTOLOAD <key> to add a key
        if status is-interactive
          set -lx SHELL fish
          keychain --eval $SSH_KEYS_TO_AUTOLOAD | source
        end
      '';

      shellAliases = {
        cat = "${pkgs.bat}/bin/bat -p";
        ls = "${pkgs.eza}/bin/eza --icons";
        man = "${lib.getExe pkgs.bat-extras.batman}";
        gss = "git status -s";
        glo = "git log --oneline";
        gp = "git push";
        gl = "git pull";
      };
    };

    programs.zsh = {
      enable = false;

      enableCompletion = true;

      initExtra = ''
        bindkey -e

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

        zstyle ':completion:*' menu select
        HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=""
        HISTORY_SUBSTRING_SEARCH_PREFIXED=1
        bindkey "^[[A" history-substring-search-up
        bindkey "^[[B" history-substring-search-down
      '';
    };

    home.file = {
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
