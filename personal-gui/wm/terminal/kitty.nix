{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.terminal;
  cCfg = cfg.colors;
in {
  config = mkIf (cfg.enable && cfg.kind == "kitty") {
    terminal.command = mkDefault "${pkgs.kitty}/bin/kitty";
    programs.kitty = {
      enable = true;
      font = {
        name = cfg.font.family;
        size = cfg.font.size;
      };
      settings = let
        colorCfg = value: mkIf (value != null) "#${value}";
        colorCfgNormal = color: colorCfg color.normal;
        colorCfgBright = color:
          if color.bright != null
          then "#${color.bright}"
          else colorCfgNormal color;
      in {
        confirm_os_window_close = 0;

        background = colorCfg cCfg.background;
        foreground = colorCfg cCfg.foreground;

        color0 = colorCfgNormal cCfg.black;
        color8 = colorCfgBright cCfg.black;

        color1 = colorCfgNormal cCfg.red;
        color9 = colorCfgBright cCfg.red;

        color2 = colorCfgNormal cCfg.green;
        color10 = colorCfgBright cCfg.green;

        color3 = colorCfgNormal cCfg.yellow;
        color11 = colorCfgBright cCfg.yellow;

        color4 = colorCfgNormal cCfg.blue;
        color12 = colorCfgBright cCfg.blue;

        color5 = colorCfgNormal cCfg.magenta;
        color13 = colorCfgBright cCfg.magenta;

        color6 = colorCfgNormal cCfg.cyan;
        color14 = colorCfgBright cCfg.cyan;

        color7 = colorCfgNormal cCfg.white;
        color15 = colorCfgBright cCfg.white;

        selection_foreground = colorCfg cCfg.selectionForeground;
      };
    };
    wayland.windowManager.sway.config.terminal = "${config.terminal.command}";
    xsession.windowManager.i3.config.terminal = "${config.terminal.command}";
  };
}
