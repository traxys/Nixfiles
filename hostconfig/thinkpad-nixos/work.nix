{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    workAddr = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = {
    workAddr = "quentin.boyer@***REMOVED***";

    home.packages = [
      (pkgs.writeShellScriptBin "nwadminSendmail" ''
        #!/usr/bin/env sh
        # shellcheck disable=SC2029

        ssh nwadmin "/usr/sbin/sendmail -r ${config.workAddr} $*"
        exit $?
      '')
    ];

    programs.git-series-manager = {
      enable = true;
      settings = {
        sendmail_args = ["--sendmail-cmd=nwadminSendmail" "--to=dl-bxi-sw-ll-patches@***REMOVED***"];
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
