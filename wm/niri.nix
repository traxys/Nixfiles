{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf (config.traxys.wm == "niri") {
  home.packages = with pkgs; [
    swaybg
    config.traxys.pkgs.xwayland-satellite-unstable
  ];

  services.gnome-keyring.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    configPackages = [ config.programs.niri.package ];
  };

  traxys.waybar.enable = true;
  traxys.waybar.modules."niri/window".enable = true;
  traxys.waybar.modules."niri/workspaces".enable = true;

  programs.niri = {
    enable = true;
    package = config.traxys.pkgs.niri-unstable;

    settings =
      let
        wallpaper = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/ba
ckgrounds/nixos/nix-wallpaper-simple-dark-gray.png";
      in
      {
        xwayland-satellite.path = lib.getExe config.traxys.pkgs.xwayland-satellite-unstable;

        input = {
          keyboard = {
            xkb.layout = "fr(ergol),us";
            xkb.options = "compose:102";
            numlock = true;
          };
          touchpad = {
            natural-scroll = false;
          };
        };

        spawn-at-startup = [
          { command = [ "waybar" ]; }
          { command = [ "${pkgs.mako}/bin/mako" ]; }
          { command = [ "signal-desktop" ]; }
          { command = [ "discord" ]; }
          { command = [ "firefox" ]; }
          { command = [ "element-desktop" ]; }
          { command = [ "thunderbird" ]; }
          { command = [ "${pkgs.plasma5Packages.kdeconnect-kde}/libexec/kdeconnectd" ]; }
          {
            command = [
              "swaybg"
              "--image"
              wallpaper
            ];
          }
        ];

        layer-rules = [
          {
            matches = [ { namespace = "^notifications$"; } ];
            block-out-from = "screencast";
          }
        ];

        window-rules = [
          {
            matches = [
              { app-id = "teams-for-linux"; }
              { app-id = "discord"; }
              { app-id = "signal"; }
            ];

            block-out-from = "screencast";
          }
        ];

        binds =
          let
            inherit (config.lib.niri.actions)
              spawn
              close-window
              show-hotkey-overlay
              toggle-overview
              focus-column-left
              focus-column-right
              focus-window-up
              focus-window-down
              move-column-left
              move-column-right
              move-window-up
              move-window-down
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
              screenshot
              ;
          in
          {
            # "Print".action = spawn "sh" "-c" ''
            #   ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png
            # '';
            "Print".action = screenshot;
            "Mod+Shift+l" = {
              action = spawn "${pkgs.swaylock-fancy}/bin/swaylock-fancy";
              hotkey-overlay.title = "Lock the screen";
            };
            "Mod+e" = {
              action = spawn "${config.programs.rofi.package}/bin/rofi" "-show" "drun" "-show-icons";
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
            "Mod+Shift+Up".action = move-window-up;
            "Mod+Shift+Down".action = move-window-down;

            "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
            "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
            "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
            "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;

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

            "Mod+Minus".action = set-column-width "-10%";
            "Mod+Plus".action = set-column-width "+10%";
            "Mod+Shift+Minus".action = set-window-height "-10%";
            "Mod+Shift+Plus".action = set-window-height "+10%";

            # Media Keys
            "XF86AudioRaiseVolume" = {
              action = spawn "${pkgs.pulseaudio}/bin/pactl" "set-sink-volume" "@DEFAULT_SINK@" "'+10%'";
              allow-when-locked = true;
            };
            "XF86AudioLowerVolume" = {
              action = spawn "${pkgs.pulseaudio}/bin/pactl" "set-sink-volume" "@DEFAULT_SINK@" "'-10%'";
              allow-when-locked = true;
            };
            "XF86AudioMute" = {
              action = spawn "${pkgs.pulseaudio}/bin/pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle";
              allow-when-locked = true;
            };
            "XF86AudioPlay" = {
              action = spawn "${pkgs.playerctl}/bin/playerctl" "-p" "spotify" "play-pause";
              allow-when-locked = true;
            };
            "XF86AudioNext".action = spawn "${pkgs.playerctl}/bin/playerctl" "-p" "spotify" "next";
            "XF86AudioPrev".action = spawn "${pkgs.playerctl}/bin/playerctl" "-p" "spotify" "previous";

            "XF86MonBrightnessDown" = {
              action = spawn (lib.getExe pkgs.brightnessctl) "set" "10%-";
              allow-when-locked = true;
            };
            "XF86MonBrightnessUp" = {
              action = spawn (lib.getExe pkgs.brightnessctl) "set" "10%+";
              allow-when-locked = true;
            };

            "XF86Display".action = spawn (lib.getExe' pkgs.wl-mirror "wl-present") "mirror";
          };
      };
  };
}
