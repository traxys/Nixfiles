{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins;
let
  cfg = config.wm;
  common = import ./i3like-utils.nix { inherit config; };

  startupNotifications =
    if cfg.notifications.enable then
      [
        {
          command = "${pkgs.mako}/bin/mako";
          always = true;
        }
      ]
    else
      [ ];

  startup = startupNotifications ++ cfg.startup;
in
{
  config = mkIf (cfg.enable && cfg.kind == "sway") {
    home.packages = with pkgs; [ sway ] ++ (if cfg.wallpaper != null then [ pkgs.swaybg ] else [ ]);

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
      LIBSEAT_BACKEND = "logind";
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };

    programs.rofi.package = pkgs.rofi-wayland;

    services.mako = mkIf cfg.notifications.enable {
      enable = true;
      settings = {
        inherit (cfg.notifications) font;
        margin = "20,20,5,5";
        default-timeout = cfg.notifications.defaultTimeout;
        "mode=do-not-disturb" = {
          invisible = 1;
        };
      };
    };

    traxys.waybar.enable = true;
    traxys.waybar.modules."sway/workspaces".enable = true;
    traxys.waybar.modules."sway/mode".enable = true;
    traxys.waybar.modules."sway/window".enable = true;

    wm.printScreen.command = mkDefault "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
    wm.exit.command = mkDefault "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

    wayland.windowManager.sway = {
      enable = true;
      extraConfig = mkMerge [
        (mkIf (cfg.wallpaper != null) ''
          output "*" bg ${cfg.wallpaper} fill
        '')
        ''
          for_window [app_id="discord"] border none
        ''
      ];
      config = {
        inherit startup;
        inherit (cfg) modifier;
        bars = [ { command = "waybar"; } ];
        input =
          let
            inherit (config.extraInfo) inputs;
            inputsCfg = [
              (
                if inputs.touchpad != null then
                  {
                    name = inputs.touchpad;
                    value = {
                      dwt = "disable";
                    };
                  }
                else
                  null
              )
              {
                name = "type:keyboard";
                value = {
                  xkb_layout = "fr(ergol),us";
                  xkb_options = "compose:102";
                };
              }
            ];
          in
          builtins.listToAttrs (builtins.filter (s: s != null) inputsCfg);
        output = config.extraInfo.outputs;
        fonts = common.mkFont cfg.font;
        window = {
          titlebar = true;
          commands = [
            {
              criteria.class = "davmail-DavGateway";
              command = "floating enable";
            }
            {
              criteria.window_type = "menu";
              command = "floating enable";
            }
          ];
        };
        inherit (common) keybindings;
        inherit (common) workspaceOutputAssign;
        inherit (common) assigns;
        seat."*" = {
          xcursor_theme = "${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}";
        };
      };
    };
  };
}
