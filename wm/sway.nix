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
  options = {
    traxys.waybar =
      with lib.types;
      let
        jsonFormat = pkgs.formats.json { };

        modulesListOpt = mkOption {
          type = listOf (submodule {
            options = {
              name = mkOption { type = str; };
              priority = mkOption { type = types.int; };
            };
          });
          default = [ ];
          apply = opt: builtins.map (v: v.name) (lib.sortOn (v: v.priority) opt);
        };
      in
      {
        modules-left = modulesListOpt;
        modules-center = modulesListOpt;
        modules-right = modulesListOpt;

        modules =
          let
            moduleOpt =
              {
                side ? "right",
                enable ? true,
                priority,
                extraOpts ? { },
                settings,
              }:
              {
                enable = mkOption {
                  type = bool;
                  default = enable;
                };

                side = mkOption {
                  type = enum [
                    "left"
                    "center"
                    "right"
                  ];
                  default = side;
                };
                priority = mkOption {
                  type = int;
                  default = priority;
                };

                settings = mkOption {
                  inherit (jsonFormat) type;
                  default = settings;
                };
              }
              // extraOpts;

            is = "<span font='20' rise='-3000' line_height='0.7'>";
            ie = "</span>";
          in
          {
            # Left

            "custom/khal" = moduleOpt {
              enable = false;
              side = "left";
              priority = 5;
              settings = {
                format = "{}";
                tooltip = true;
                interval = 300;
                format-icons = {
                  default = "";
                };
                exec = "${lib.getExe pkgs.python3} ${./waybar-khal.py}";
                return-type = "json";
              };
            };

            "network#wifi" = moduleOpt {
              side = "left";
              enable = false;
              priority = 10;
              extraOpts = {
                interface = mkOption { type = str; };
              };
              settings = {
                inherit (config.traxys.waybar.modules."network#wifi") interface;
                format-wifi = "{essid} ({signalStrength}%) ";
                format-disconnected = "";
              };
            };

            "sway/workspaces" = moduleOpt {
              side = "left";
              priority = 20;
              settings = {
                persistent-workspaces = {
                  "" = [ ];
                  "" = [ ];
                  "1:" = [ ];
                };
                numeric-first = true;
              };
            };

            "sway/mode" = moduleOpt {
              side = "left";
              priority = 30;
              settings = { };
            };

            # Center

            "sway/window" = moduleOpt {
              side = "center";
              priority = 10;
              settings = {
                max-length = 50;
              };
            };

            # Right

            "cpu" = moduleOpt {
              priority = 10;
              settings = {
                format = "${is}${ie} {load}";
              };
            };

            "memory" = moduleOpt {
              priority = 20;
              settings = {
                format = "${is}${ie} {used:.0f}G/{total:.0f}G";
              };
            };

            "disk#home" = moduleOpt {
              priority = 30;
              settings = {
                path = "/home";
                format = "${is}${ie} {free}";
              };
            };

            "disk#root" = moduleOpt {
              priority = 40;
              settings = {
                path = "/";
                format = " {percentage_free}%";
              };
            };

            "battery" = moduleOpt {
              enable = false;
              priority = 50;
              settings = {
                format = "{capacity}% ${is}{icon}${ie}";
                format-icons = [
                  ""
                  ""
                  ""
                  ""
                  ""
                ];
              };
            };

            "clock" = moduleOpt {
              priority = 60;
              settings = {
                format-alt = "{:%a, %d. %b  %H:%M}";
              };
            };

            "tray" = moduleOpt {
              priority = 70;
              settings = { };
            };

            "pulseaudio" = moduleOpt {
              priority = 80;
              settings = { };
            };
          };
      };
  };

  config =
    let
      addKey =
        key: value: attrs:
        attrs // { ${key} = attrs.${key} // value; };
      modulesList =
        lib.foldlAttrs
          (
            acc: name: mod:
            addKey mod.side { ${name} = mod; } acc
          )
          {
            center = { };
            left = { };
            right = { };
          }
          config.traxys.waybar.modules;
      enabledModulesSide = side: lib.filterAttrs (_: v: v.enable) modulesList.${side};
      moduleListSide =
        side:
        lib.mapAttrsToList (name: v: {
          inherit name;
          inherit (v) priority;
        }) (enabledModulesSide side);
    in
    mkIf (cfg.enable && cfg.kind == "sway") {
      traxys.waybar.modules-left = moduleListSide "left";
      traxys.waybar.modules-center = moduleListSide "center";
      traxys.waybar.modules-right = moduleListSide "right";

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

      programs = {
        waybar = {
          enable = true;
          style = builtins.readFile ./waybar.css;
          settings = [
            (
              {
                layer = "top";
                position = "bottom";
                inherit (config.traxys.waybar) modules-left;
                inherit (config.traxys.waybar) modules-center;
                inherit (config.traxys.waybar) modules-right;
              }
              // (builtins.mapAttrs (_: v: v.settings) (
                lib.filterAttrs (_: v: v.enable) config.traxys.waybar.modules
              ))
            )
          ];
        };
      };

      wm.printScreen.command = mkDefault "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png";
      wm.exit.command = mkDefault "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

      wayland.windowManager.sway = {
        enable = true;
        extraConfig = mkIf (cfg.wallpaper != null) ''
          output "*" bg ${cfg.wallpaper} fill
        '';
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
