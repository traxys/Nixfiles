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
              mode = [
                "n"
                "i"
              ];
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
      pkgs.python3.pkgs.tappy
    ];

    programs.git-series-manager = {
      enable = true;
      settings = {
        sendmail_args = [
          "--sendmail-cmd=nwadminSendmail"
          "--to=dl-bxi-sw-ll-patches@***REMOVED***"
        ];
        repo_url_base = "https://***REMOVED***/scm/bril/";
        ci_url = "https://sf.bds.***REMOVED***/jenkins/job/BRIL/job/\${component}/job/\${branch}/\${ci_job}";
        editor = "nvim";
      };
    };

    programs.zsh.shellAliases = {
      gemail = ''git send-email --sendmail-cmd="nwadminSendmail" --to="dl-bxi-sw-ll-patches@***REMOVED***"'';
    };
  };
}
