{
  pkgs,
  lib,
  ...
}:
let
  inherit (import ../../str-obf.nix lib) decode;
  workDomain = "hbdsiyvfirq.ziy";
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
    ];

    home.sessionVariables = {
      WORK_DOMAIN = decode workDomain;
    };
  };
}
