{
  config,
  lib,
  pkgs,
  ...
}:
{
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

  imports = [ ./i3like.nix ];

  gtk = {
    enable = true;
    font = {
      name = "DejaVu Sans";
    };
    theme.name = "Adwaita";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home.packages = with pkgs; [ kdePackages.breeze ];

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    size = 24;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
  };

  programs.foot.settings.colors."16" = "ff9e64";
  programs.foot.settings.colors."17" = "db4b4b";

  home.sessionVariables = {
    EXA_COLORS = "xx=38;5;8";
  };

  programs.rofi = {
    enable = true;
    theme = "solarized_alternate";
    terminal = "${config.terminal.command}";
  };

  wm =
    let
      mod = config.wm.modifier;
    in
    {
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

      workspaces = {
        moveModifier = "Shift";
        definitions = {
          "1:" = {
            key = "1";
          };
          "2:" = {
            key = "2";
          };
          "3:" = {
            key = "3";
          };
          "4" = {
            key = "4";
          };
          "5" = {
            key = "5";
          };
          "6" = {
            key = "6";
          };
          "7" = {
            key = "7";
          };
          "" = {
            key = "8";
            assign = [ "Spotify" ];
          };
          "" = {
            key = "g";
            assign = [
              "Element"
              "Signal"
              "Discord"
            ];
          };
          "" = {
            key = "h";
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
    };
}
