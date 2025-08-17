{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf (config.traxys.wm == "sway") {
  xdg.portal = {
    enable = true;
    config = {
      sway = {
        default = "gtk";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      };
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  home.packages = with pkgs; [
    sway
    swaybg
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
    LIBSEAT_BACKEND = "logind";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  programs.rofi.package = pkgs.rofi-wayland;

  services.mako = {
    enable = true;
    settings = {
      font = "hack nerd font 10";
      margin = "20,20,5,5";
      default-timeout = 7000;
      "mode=do-not-disturb" = {
        invisible = 1;
      };
    };
  };

  traxys.waybar.enable = true;
  traxys.waybar.modules."sway/workspaces".enable = true;
  traxys.waybar.modules."sway/mode".enable = true;
  traxys.waybar.modules."sway/window".enable = true;

  wayland.windowManager.sway = {
    enable = true;
    extraConfig =
      let
        wallpaper = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nix-wallpaper-simple-dark-gray.png";
      in
      ''
        output "*" bg ${wallpaper} fill
        for_window [app_id="discord"] border none
      '';
    config =
      let
        mod = "Mod4";
      in
      {
        modifier = mod;

        bars = [ { command = "waybar"; } ];

        startup = [
          {
            command = "${pkgs.mako}/bin/mako";
            always = true;
          }
          {
            command = lib.getExe (
              pkgs.sway-assign-cgroups.override {
                python3Packages = pkgs.python3Packages // {
                  dbus-next = pkgs.python3Packages.dbus-next.overridePythonAttrs (_: {
                    doCheck = false;
                  });
                };
              }
            );
          }
          { command = "signal-desktop"; }
          { command = "discord"; }
          { command = "firefox"; }
          { command = "element-desktop"; }
          { command = "thunderbird"; }
          { command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK"; }
          {
            command = "hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK";
          }
          {
            command = "${pkgs.plasma5Packages.kdeconnect-kde}/libexec/kdeconnectd";
            always = true;
          }
        ];

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

        fonts = {
          names = [ "Hack Nerd Font" ];
          style = "Regular";
          size = 14.0;
        };

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

        keybindings = {
          "Print" = ''
            exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png
          '';

          "${mod}+Shift+e" = ''
            exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'
          '';

          "${mod}+Shift+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";

          "${mod}+e" = "exec ${config.programs.rofi.package}/bin/rofi -show drun -show-icons";

          "${mod}+1" = "workspace 1:";
          "${mod}+Shift+1" = "move container to workspace 1:";
          "${mod}+2" = "workspace 2:";
          "${mod}+Shift+2" = "move container to workspace 2:";
          "${mod}+3" = "workspace 3:";
          "${mod}+Shift+3" = "move container to workspace 3:";
          "${mod}+4" = "workspace 4";
          "${mod}+Shift+4" = "move container to workspace 4";
          "${mod}+5" = "workspace 5";
          "${mod}+Shift+5" = "move container to workspace 5";
          "${mod}+6" = "workspace 6";
          "${mod}+Shift+6" = "move container to workspace 6";
          "${mod}+7" = "workspace 7";
          "${mod}+Shift+7" = "move container to workspace 7";
          "${mod}+8" = "workspace ";
          "${mod}+Shift+8" = "move container to workspace ";
          "${mod}+g" = "workspace ";
          "${mod}+Shift+g" = "move container to workspace ";
          "${mod}+h" = "workspace ";
          "${mod}+Shift+h" = "move container to workspace ";

          # Media Keys
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+10%'";
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-10%'";
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify previous";

          "XF86MonBrightnessDown" = "exec ${lib.getExe pkgs.brightnessctl} set 10%-";
          "XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.brightnessctl} set 10%+";

          "XF86Display" = "exec ${lib.getExe' pkgs.wl-mirror "wl-present"} mirror";

          "${mod}+space" = "exec foot nvim +WikiIndex";
          "${mod}+Shift+space" = "exec foot nvim +WikiPages";

          # Gromit
          "Ctrl+Shift+I" = "exec ${pkgs.gromit-mpx}/bin/gromit-mpx -a";
          "Ctrl+Shift+D" = "exec ${pkgs.gromit-mpx}/bin/gromit-mpx -q";
          "Ctrl+Shift+H" = "exec ${pkgs.gromit-mpx}/bin/gromit-mpx -c";

          # Change keyboard layout
          "${mod}+dollar" = "input type:keyboard xkb_switch_layout next"; # Dvorak
          "${mod}+grave" = "input type:keyboard xkb_switch_layout next"; # Qwerty

          # Focus
          "${mod}+Left" = "focus left";
          "${mod}+Right" = "focus right";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Right" = "move right";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";

          # Layout
          "${mod}+n" = "fullscreen toggle";
          "${mod}+o" = "layout tabbed";

          # Misc
          "${mod}+Shift+Q" = "kill";
          "${mod}+Shift+J" = "reload";
          "${mod}+Return" = "exec ${config.terminal.command}";
          "${mod}+p" = "mode resize";
          "${mod}+Shift+P" = "restart";
          "${mod}+Shift+S" = "exec ${config.programs.rofi.package}/bin/rofi -show ssh";
        };

        assigns = {
          "" = [ { class = "Ppotify"; } ];

          "" = [
            { class = "Element"; }
            { class = "Signal"; }
            { class = "Discord"; }
          ];

          "" = [ { class = "Thunderbird"; } ];
        };

        seat."*" = {
          xcursor_theme = "${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}";
        };
      };
  };
}
