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
    workAddr = "quentin.boyer@eviden.com";

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
      pkgs.python3.pkgs.tappy
    ];

    programs.git-series-manager = {
      enable = true;
      settings = {
        sendmail_args = [
          "--sendmail-cmd=nwadminSendmail"
          "--to=dl-bxi-sw-ll-patches@eviden.com"
        ];
        repo_url_base = "https://bitbucketbdsfr.fsc.atos-services.net/scm/bril/";
        ci_url = "https://sf.bds.atos.net/jenkins/job/BRIL/job/\${component}/job/\${branch}/\${ci_job}";
        editor = "nvim";
      };
    };

    programs.zsh.shellAliases = {
      gemail = ''git send-email --sendmail-cmd="nwadminSendmail" --to="dl-bxi-sw-ll-patches@eviden.com"'';
    };
  };
}
