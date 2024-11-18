{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    workAddr = lib.mkOption { type = lib.types.str; };
  };

  config = {
    workAddr = "quentin.boyer@***REMOVED***";

    extraNixvim = [
      (
        { helpers, ... }:
        {
          extraConfigLuaPre = ''
            team_picker = dofile("${./telescope-team.lua}")
          '';
          keymaps = [
            {
              key = "<leader>R";
              mode = [ "n" ];
              action = helpers.mkRaw "team_picker";
            }
          ];
          commands = {
            Review = "lua team_picker()";
          };
        }
      )
    ];

    home.packages = [
      (pkgs.writeShellScriptBin "nwadminSendmail" ''
        #!/usr/bin/env sh
        # shellcheck disable=SC2029

        ssh nwadmin "/usr/sbin/sendmail -r ${config.workAddr} $*"
        exit $?
      '')
      (pkgs.writeShellScriptBin "mgit" ''
        #!/usr/bin/env bash

        if [[ -z $BUILD_DIR ]]; then
          BUILD_DIR=build
        fi

        cd "$(git rev-parse --show-toplevel)" || {
          echo "can't cd to toplevel"
          exit 255
        }

        if [[ ! -d $BUILD_DIR ]]; then
          echo "build directory '$BUILD_DIR' not found"
          exit 1
        fi

        meson compile -C "$BUILD_DIR" "$@"
      '')
      pkgs.python3.pkgs.tappy
    ];

    programs.git-series-manager = {
      enable = true;
      settings = {
        sendmail_args = [
          # Davmail
          # "--from=${config.workAddr}"
          # "--smtp-server=127.0.0.1"
          # "--smtp-user=${config.workAddr}"
          # "--smtp-pass=aaaa"
          # "--smtp-encryption=plain"
          # "--smtp-server-port=1025"
          "--sendmail-cmd=nwadminSendmail"
          "--to=dl-bxi-sw-ll-patches@***REMOVED***"
        ];
        repo_url_base = "https://***REMOVED***/scm/bril/";
        ci_url = "https://sf.bds.***REMOVED***/jenkins/job/BRIL/job/\${component}/job/\${branch}/\${ci_job}";
        editor = "nvim";
      };
    };

    programs.fish.shellAliases = {
      gemail = ''git send-email --sendmail-cmd="nwadminSendmail" --to="dl-bxi-sw-ll-patches@***REMOVED***"'';
    };
  };
}
