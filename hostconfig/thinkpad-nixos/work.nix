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
    workAddr = "quentin.boyer@atos.net";

    home.packages = [
      (pkgs.writeShellScriptBin "gpt" ''
        #!/usr/bin/env bash

        if [ -n "$2" ]; then
            VER=" $1"
            shift
        fi

        DIR="$(basename "$(git rev-parse --show-toplevel)")"
        git format-patch --subject-prefix="PATCH $DIR$VER" "$@"
      '')
      (pkgs.writeShellScriptBin "nwadminSendmail" ''
        #!/usr/bin/env sh
        # shellcheck disable=SC2029

        ssh nwadmin "/usr/sbin/sendmail -r ${config.workAddr} $*"
        exit $?
      '')
    ];

    programs.zsh.shellAliases = {
      gemail = ''git send-email --sendmail-cmd="nwadminSendmail" --to="dl-bxi-sw-ll-patches@atos.net"'';
    };
  };
}
