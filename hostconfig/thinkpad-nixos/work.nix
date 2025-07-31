{
  pkgs,
  lib,
  config,
  ...
}:
let
  rhelVersion = "9";
  bxiImageVersion = "0.7.1";
  inherit (import ../../str-obf.nix lib) decode;
  workDomain = "lenmlx.ziy";
  oldWorkDomain = "hsid.xls";
  scmDomain = "gnsgrzwlsgmdjf.jdz.hsid-dlfenzld.xls";
in
{
  options = {
    workAddr = lib.mkOption { type = lib.types.str; };
  };

  config = {
    workAddr = "quentin.boyer@${decode workDomain}";

    programs.nixvim =
      { lib, ... }:
      {
        extraConfigLuaPre = ''
          team_picker = dofile("${./telescope-team.lua}")
        '';
        keymaps = [
          {
            key = "<leader>R";
            mode = [ "n" ];
            action = lib.nixvim.mkRaw "team_picker";
          }
        ];
        commands = {
          Review = "lua team_picker()";
        };
      };

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
      (pkgs.writeShellScriptBin "podman-bxilint" ''
        #!/usr/bin/env bash

        cd "$(git rev-parse --show-toplevel)" || {
          echo "can't cd to toplevel"
          exit 255
        }

        kernel_path=$(meson introspect build --buildoptions | jq -r '.[] | select(.name == "kernel_path") | .value')

        if [[ -z $kernel_path ]]; then
          kernel_path=/usr/src/kernels/$(uname -r)
        fi

        kernel_path=$(realpath "$kernel_path")
        curdir=$(realpath .)

        podman run -it --rm -v "$curdir:$curdir" -v "$kernel_path:$kernel_path" -w "$curdir" \
          registry.sf.bds.${decode oldWorkDomain}/bril-docker-release/bxi-rhel${rhelVersion}:${bxiImageVersion} \
          bxilint "$@"
      '')
      pkgs.python3.pkgs.tappy
    ];

    home.sessionVariables = {
      WORK_DOMAIN = decode workDomain;
    };

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
          "--to=dl-bxi-sw-ll-patches@${decode workDomain}"
        ];
        repo_url_base = "https://${decode scmDomain}/scm/bril/";
        ci_url = "https://sf.bds.${decode oldWorkDomain}/jenkins/job/BRIL/job/\${component}/job/\${branch}/\${ci_job}";
        editor = "nvim";
      };
    };

    programs.fish.shellAliases = {
      gemail = ''git send-email --sendmail-cmd="nwadminSendmail" --to="dl-bxi-sw-ll-patches@${decode workDomain}"'';
    };
  };
}
