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
  config = mkIf (cfg.enable && cfg.kind == "foot") {
    terminal.command = mkDefault "${pkgs.foot}/bin/foot";
    programs.foot = {
      enable = true;
      settings = {
        colors = let
          colorCfg = value: mkIf (value != null) value;
          colorCfgNormal = color: colorCfg color.normal;
          colorCfgBright = color:
            if color.bright != null
            then color.bright
            else colorCfgNormal color;
        in {
          background = colorCfg cCfg.background;
          foreground = colorCfg cCfg.foreground;

          regular0 = colorCfgNormal cCfg.black;
          bright0 = colorCfgBright cCfg.black;

          regular1 = colorCfgNormal cCfg.red;
          bright1 = colorCfgBright cCfg.red;

          regular2 = colorCfgNormal cCfg.green;
          bright2 = colorCfgBright cCfg.green;

          regular3 = colorCfgNormal cCfg.yellow;
          bright3 = colorCfgBright cCfg.yellow;

          regular4 = colorCfgNormal cCfg.blue;
          bright4 = colorCfgBright cCfg.blue;

          regular5 = colorCfgNormal cCfg.magenta;
          bright5 = colorCfgBright cCfg.magenta;

          regular6 = colorCfgNormal cCfg.cyan;
          bright6 = colorCfgBright cCfg.cyan;

          regular7 = colorCfgNormal cCfg.white;
          bright7 = colorCfgBright cCfg.white;

		  urls = colorCfg cCfg.urls;

          selection-foreground = colorCfg cCfg.selection.foreground;
		  selection-background = colorCfg cCfg.selection.background;
        };
        main = {
          font = "${cfg.font.family}:size=${toString cfg.font.size}";
        };
      };
    };
    wayland.windowManager.sway.config.terminal = "${config.terminal.command}";
  };
}
