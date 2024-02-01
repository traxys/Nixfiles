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
      (pkgs.writeShellScriptBin "gpt" (builtins.readFile ./gpt))
      (pkgs.writeShellScriptBin "nwadminSendmail" ''
        #!/usr/bin/env sh
        # shellcheck disable=SC2029

        ssh nwadmin "/usr/sbin/sendmail -r ${config.workAddr} $*"
        exit $?
      '')
    ];

    programs.zsh.shellAliases = {
      gemail = ''git send-email --sendmail-cmd="nwadminSendmail" --to="dl-bxi-sw-ll-patches@***REMOVED***"'';
    };
  };
}
