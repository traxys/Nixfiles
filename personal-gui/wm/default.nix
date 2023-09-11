{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./terminal ./i3like.nix];

  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
    };
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };

  terminal = {
    enable = true;
    kind = "foot";

    colors = {
      background = "1a1b26";
      foreground = "c0caf5";

      black = {
        normal = "15161e";
        bright = "414868";
      };
      red = {normal = "f7768e";};
      green = {normal = "9ece6a";};
      yellow = {normal = "e0af68";};
      blue = {normal = "7aa2f7";};
      magenta = {normal = "bb9af7";};
      cyan = {normal = "7dcfff";};
      white = {
        normal = "a9b1d6";
        bright = "c0caf5";
      };

      urls = "73daca";

      selection = {
        foreground = "c0caf5";
        background = "33467c";
      };
    };
    font = {
      family = "Hack Nerd Font Mono";
      size = lib.mkDefault 10;
    };
  };

  programs.foot.settings.colors."16" = "ff9e64";
  programs.foot.settings.colors."17" = "db4b4b";

  home.sessionVariables = {
    EXA_COLORS = "xx=38;5;8";
  };

  wm = let
    mod = config.wm.modifier;
  in {
    enable = true;
    kind = "sway";
    modifier = "Mod4";

    font = {
      name = "Hack Nerd Font";
      style = "Regular";
      size = 14.0;
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
      {command = "signal-desktop";}
      {command = "discord";}
      {command = "firefox";}
      {command = "element-desktop";}
      {command = "thunderbird";}
      {command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK";}
      {command = "hash dbus-update-activation-environment 2>/dev/null && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK";}
      {
        command = "${pkgs.plasma5Packages.kdeconnect-kde}/libexec/kdeconnectd";
        always = true;
      }
    ];

    workspaces = {
      moveModifier = "Shift";
      definitions = {
        "1:" = {key = "ampersand";};
        "2:" = {key = "bracketleft";};
        "3:" = {key = "braceleft";};
        "4" = {key = "braceright";};
        "5" = {key = "parenleft";};
        "6" = {key = "equal";};
        "7" = {key = "asterisk";};
        "" = {
          key = "parenright";
          assign = ["Spotify"];
        };
        "" = {
          key = "w";
          assign = [
            "Element"
            "Signal"
            "Discord"
          ];
        };
        "" = {
          key = "m";
          assign = ["Thunderbird"];
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
      "${mod}+u" = "fullscreen toggle";
      "${mod}+comma" = "layout tabbed";

      # Misc
      "${mod}+Shift+semicolon" = "kill";
      "${mod}+Shift+J" = "reload";
      "${mod}+Return" = "exec ${config.terminal.command}";
      "${mod}+p" = "mode resize";
      "${mod}+Shift+P" = "restart";
      "${mod}+Shift+S" = "exec ${config.programs.rofi.package}/bin/rofi -show ssh";
    };
  };
}
