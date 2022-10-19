{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  mkColor = mkOption {
    type = types.nullOr types.str;
    default = null;
  };
  mkColorPair = {
    normal = mkColor;
    bright = mkColor;
  };
  cfg = config.terminal;
  cCfg = cfg.colors;
in {
  imports = [./foot.nix ./kitty.nix];

  options = {
    terminal = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Manage terminal";
      };
      kind = mkOption {
        type = types.enum ["foot" "kitty"];
        default = "foot";
        description = "The terminal to be used";
      };
      command = mkOption {
        type = types.str;
        description = "The command used to launch the terminal";
      };
      colors = {
        background = mkColor;
        foreground = mkColor;

        black = mkColorPair;
        red = mkColorPair;
        green = mkColorPair;
        yellow = mkColorPair;
        blue = mkColorPair;
        magenta = mkColorPair;
        cyan = mkColorPair;
        white = mkColorPair;

        urls = mkColor;

        selection = {
          background = mkColor;
          foreground = mkColor;
        };
      };
      font = {
        size = mkOption {
          type = types.int;
          default = 12;
          description = "terminal font size";
        };
        family = mkOption {
          type = types.str;
          default = "monospace";
          description = "font family";
        };
      };
    };
  };
}
