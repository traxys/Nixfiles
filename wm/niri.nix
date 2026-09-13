{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf (config.traxys.wm == "niri") {
  home.packages = with pkgs; [
    swaybg
    config.traxys.pkgs.xwayland-satellite
    wl-mirror
    nautilus
    evolution-data-server
  ];

  services.gnome-keyring.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    configPackages = [ config.programs.niri.package ];
  };

  traxys.waybar.enable = false;
  traxys.waybar.modules."niri/window".enable = true;
  traxys.waybar.modules."niri/workspaces".enable = true;

  xdg.configFile."phonto/config.toml".source = pkgs.writers.writeTOML "phonto-config.toml" {
    search_paths = [
      {
        path = pkgs.video-wallpapers;
        depth = 1;
      }
    ];
  };

  programs.noctalia = {
    enable = true;

    package = pkgs.noctalia;

    settings = {
      bar.default.start = [
        "launcher"
        "workspaces"
        "active_window"
      ];

      battery.warning_threshold = 20;

      calendar.enabled = true;

      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "lock and hibernate"
        ];

        behavior.lock = {
          action = "lock";
          enabled = true;
          timeout = 300.0;
        };

        behavior."lock and hibernate" = {
          action = "command";
          command = "systemctl suspend-then-hibernate";
          enabled = true;
          timeout = 1800.0;
        };

        behavior.screen-off = {
          action = "screen_off";
          enabled = true;
          timeout = 360.0;
        };
      };

      location.auto_locate = true;

      lockscreen = {
        blurred_desktop = true;
        blur_intensity = 0.70;
        tint_intensity = 0.50;
      };

      shell.telemetry_enabled = true;
      theme.builtin = "Tokyo-Night";
      wallpaper.enabled = false;

      widget = {
        active_window.max_length = 360;
        battery = {
          display_mode = "graphic";
          show_label = false;
        };
      };
    };
  };

  services.network-manager-applet.enable = lib.mkForce false;
  services.mako.enable = lib.mkForce false;

  dbus.packages = [ pkgs.evolution-data-server ];
  systemd.user.packages = [ pkgs.evolution-data-server ];

  programs.niri = {
    enable = true;
    package = config.traxys.pkgs.niri;

    settings =
      let
      in
      {
        xwayland-satellite.path = lib.getExe config.traxys.pkgs.xwayland-satellite;

        input = {
          keyboard = {
            xkb.layout = "fr(ergol),us,fr";
            xkb.options = "compose:102";
            numlock = true;
          };
          touchpad = {
            natural-scroll = false;
          };
        };

        spawn-at-startup = [
          { command = [ "noctalia" ]; }
          { command = [ "signal-desktop" ]; }
          { command = [ "discord" ]; }
          { command = [ "firefox" ]; }
          { command = [ "element-desktop" ]; }
          { command = [ "thunderbird" ]; }
          { command = [ "${pkgs.kdePackages.kdeconnect-kde}/libexec/kdeconnectd" ]; }
          { command = [ (lib.getExe pkgs.phonto-slideshow) ]; }
        ];

        layer-rules = [
          {
            matches = [ { namespace = "^noctalia-notifications"; } ];
            block-out-from = "screencast";
          }
        ];

        window-rules = [
          {
            matches = [
              { app-id = "teams-for-linux"; }
              { app-id = "discord"; }
              { app-id = "signal"; }
              {
                app-id = "foot";
                title = "aerc";
              }
            ];

            block-out-from = "screencast";
          }
          {
            opacity = 0.96;
            draw-border-with-background = false;
          }
        ];

        debug = {
          honor-xdg-activation-with-invalid-serial = [ ];
        };

        binds =
          let
            inherit (config.lib.niri.actions)
              spawn
              spawn-sh
              close-window
              show-hotkey-overlay
              toggle-overview
              focus-column-left
              focus-column-right
              focus-window-up
              focus-window-down
              move-column-left
              move-column-right
              move-window-up-or-to-workspace-up
              move-window-down-or-to-workspace-down
              move-column-to-monitor-left
              move-column-to-monitor-right
              move-column-to-monitor-up
              move-column-to-monitor-down
              focus-workspace-down
              focus-workspace-up
              move-workspace-down
              move-workspace-up
              consume-or-expel-window-left
              consume-or-expel-window-right
              consume-window-into-column
              expel-window-from-column
              switch-preset-column-width
              switch-preset-window-height
              maximize-column
              fullscreen-window
              center-column
              center-visible-columns
              set-column-width
              set-window-height
              focus-monitor-right
              focus-monitor-left
              ;
            noctalia = cmd: spawn "noctalia" "msg" cmd;
          in
          {
            # "Print".action = spawn "sh" "-c" ''
            #   ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png
            # '';
            "Print".action.screenshot = [ ];
            "Mod+Shift+l" = {
              action = noctalia [
                "session"
                "lock"
              ];
              hotkey-overlay.title = "Lock the screen";
            };
            "Mod+e" = {
              action = noctalia [
                "panel-toggle"
                "launcher"
              ];
              hotkey-overlay.title = "Run a program";
            };
            "Mod+Return" = {
              action = spawn config.terminal.command;
              hotkey-overlay.title = "Create a terminal";
            };

            "Mod+space" = {
              action = spawn "foot" "nvim" "+WikiIndex";
              hotkey-overlay.title = "Open the wiki index";
            };
            "Mod+Shift+space" = {
              action = spawn "foot" "nvim" "+WikiPages";
              hotkey-overlay.title = "Open the wiki search";
            };
            "Mod+Shift+Slash".action = show-hotkey-overlay;

            "Mod+Shift+Q" = {
              action = close-window;
              hotkey-overlay.title = "Close the current window";
            };

            "Mod+O" = {
              action = toggle-overview;
              repeat = false;
            };

            "Mod+Left".action = focus-column-left;
            "Mod+Right".action = focus-column-right;
            "Mod+Up".action = focus-window-up;
            "Mod+Down".action = focus-window-down;
            "Mod+Shift+Left".action = move-column-left;
            "Mod+Shift+Right".action = move-column-right;
            "Mod+Shift+Up".action = move-window-up-or-to-workspace-up;
            "Mod+Shift+Down".action = move-window-down-or-to-workspace-down;
            "Mod+Alt+Left".action = focus-monitor-left;
            "Mod+Alt+Right".action = focus-monitor-right;

            "Mod+Ctrl+Left".action = move-column-to-monitor-left;
            "Mod+Ctrl+Right".action = move-column-to-monitor-right;
            "Mod+Ctrl+Up".action = move-column-to-monitor-up;
            "Mod+Ctrl+Down".action = move-column-to-monitor-down;

            "Mod+Page_Down".action = focus-workspace-down;
            "Mod+Page_Up".action = focus-workspace-up;
            "Mod+Shift+Page_Down".action = move-workspace-down;
            "Mod+Shift+Page_Up".action = move-workspace-up;

            "Mod+BracketLeft".action = consume-or-expel-window-left;
            "Mod+BracketRight".action = consume-or-expel-window-right;

            "Mod+H".action = consume-window-into-column;
            "Mod+G".action = expel-window-from-column;
            "Mod+R".action = switch-preset-column-width;
            "Mod+Shift+R".action = switch-preset-window-height;
            "Mod+F".action = maximize-column;
            "Mod+Shift+F".action = fullscreen-window;
            "Mod+C".action = center-column;
            "Mod+Shift+C".action = center-visible-columns;

            "Mod+minus".action = set-column-width "-10%";
            "Mod+plus".action = set-column-width "+10%";
            "Mod+Shift+question".action = set-window-height "-10%";
            "Mod+Shift+plusminus".action = set-window-height "+10%";
            "Mod+KP_Subtract".action = set-column-width "-10%";
            "Mod+KP_Add".action = set-column-width "+10%";
            "Mod+Shift+KP_Subtract".action = set-window-height "-10%";
            "Mod+Shift+KP_Add".action = set-window-height "+10%";

            "Mod+P".action = spawn-sh "wl-mirror $(niri msg --json focused-output | jq -r .name)";

            # Media Keys
            "XF86AudioRaiseVolume" = {
              action = noctalia [
                "volume-up"
              ];
              allow-when-locked = true;
            };
            "XF86AudioLowerVolume" = {
              action = noctalia [
                "volume-down"
              ];
              allow-when-locked = true;
            };
            "XF86AudioMute" = {
              action = noctalia [
                "volume-mute"
              ];
              allow-when-locked = true;
            };
            "XF86AudioPlay" = {
              action = noctalia [
                "media"
                "toggle"
              ];
              allow-when-locked = true;
            };
            "XF86AudioNext".action = noctalia [
              "media"
              "next"
            ];
            "XF86AudioPrev".action = noctalia [
              "media"
              "previous"
            ];

            "XF86AudioMicMute" = {
              action = noctalia [
                "mic-mute"
              ];
              allow-when-locked = true;
            };

            "XF86MonBrightnessDown" = {
              action = noctalia [
                "brightness-down"
              ];
              allow-when-locked = true;
            };
            "XF86MonBrightnessUp" = {
              action = noctalia [
                "brightness-up"
              ];
              allow-when-locked = true;
            };

            "XF86Display".action = spawn (lib.getExe' pkgs.wl-mirror "wl-present") "mirror";
          };
      };
  };
}
