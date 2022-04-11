{ config, lib, pkgs, ... }:

{
  imports = [ ./terminal ./i3like.nix ];

  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
    };
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita dark";
    };
  };

  terminal = {
    enable = true;
    kind = "foot";

    colors = {
      background = "000000";
      foreground = "ffffff";

      black = {
        normal = "000000";
        bright = "545454";
      };
      red = { normal = "ff5555"; };
      green = { normal = "55ff55"; };
      yellow = { normal = "ffff55"; };
      blue = { normal = "5555ff"; };
      magenta = { normal = "ff55ff"; };
      cyan = { normal = "55ffff"; };
      white = {
        normal = "bbbbbb";
        bright = "ffffff";
      };

      selectionForeground = "000000";
    };
    font = {
      family = "Hack Nerd Font Mono";
      size = 10;
    };
  };

  wm = let mod = config.wm.modifier; in
    {
      enable = true;
      kind = "sway";
      modifier = "Mod4";

      font = {
        name = "Hack Nerd Font";
        style = "Regular";
        size = 12.0;
      };
      bar = {
        font = {
          name = "Hack Nerd Font Mono";
          style = "Regular";
          size = 11.0;
        };
      };

      wallpaper = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nix-wallpaper-simple-dark-gray.png";

      printScreen = {
        enable = true;
        keybind = "Print";
      };

      menu = {
        enable = true;
        keybind = "${mod}+e";
      };

      exit = {
        enable = true;
        keybind = "${mod}+Shift+e";
      };

      notifications = {
        enable = true;
        font = "hack nerd font 10";
        defaultTimeout = 7000;
      };

      startup = [
        { command = "signal-desktop"; }
        { command = "discord"; }
        { command = "firefox"; }
        { command = "element-desktop"; }
        { command = "thunderbird"; }
        { command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK"; }
        { command = "hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK"; }
      ];

      workspaces = {
        moveModifier = "Shift";
        definitions = {
          "1:" = { key = "ampersand"; };
          "2:" = { key = "bracketleft"; output = "DP-0"; };
          "3:" = { key = "braceleft"; };
          "4" = { key = "braceright"; };
          "5" = { key = "parenleft"; };
          "6" = { key = "equal"; };
          "7" = { key = "asterisk"; };
          "" = {
            key = "parenright";
            output = "HDMI-0";
            assign = [ "Spotify" ];
          };
          "" = {
            key = "w";
            output = "HDMI-0";
            assign = [
              "Element"
              "Signal"
              "Discord"
            ];
          };
          "" = {
            key = "m";
            output = "HDMI-0";
            assign = [ "Thunderbird" ];
          };
        };
      };

      keybindings = {
        "${mod}+Shift+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";

        # Media Keys
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '+10%'";
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ '-10%'";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify previous";

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
        "${mod}+u" = "fullscreen toggle";
        "${mod}+comma" = "layout tabbed";

        # Misc
        "${mod}+Shift+colon" = "kill";
        "${mod}+Shift+J" = "reload";
        "${mod}+Return" = "exec ${config.terminal.command}";
        "${mod}+p" = "mode resize";
        "${mod}+Shift+P" = "restart";
      };
    };
}
