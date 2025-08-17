{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.traxys.waybar =
    let
      jsonFormat = pkgs.formats.json { };

      modulesListOpt = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption { type = lib.types.str; };
              priority = lib.mkOption { type = lib.types.int; };
            };
          }
        );
        default = [ ];
        apply = opt: builtins.map (v: v.name) (lib.sortOn (v: v.priority) opt);
      };
    in
    {
      enable = lib.mkEnableOption "waybar configuration";

      mkIcon = lib.mkOption {
        type = lib.types.functionTo lib.types.str;
        readOnly = true;
        default = icon: "<span font='20' rise='-3000' line_height='0.7'>${icon}</span>";
      };

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
              enable = lib.mkOption {
                type = lib.types.bool;
                default = enable;
              };

              side = lib.mkOption {
                type = lib.types.enum [
                  "left"
                  "center"
                  "right"
                ];
                default = side;
              };

              priority = lib.mkOption {
                type = lib.types.int;
                default = priority;
              };

              settings = lib.mkOption {
                inherit (jsonFormat) type;
                default = settings;
              };
            }
            // extraOpts;

          inherit (config.traxys.waybar) mkIcon;
        in
        {
          #
          # Left
          #

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
            enable = false;
            side = "left";
            priority = 10;
            extraOpts = {
              interface = lib.mkOption { type = lib.types.str; };
            };
            settings = {
              inherit (config.traxys.waybar.modules."network#wifi") interface;
              format-wifi = "{essid} ({signalStrength}%) ";
              format-disconnected = "";
            };
          };

          "sway/workspaces" = moduleOpt {
            enable = false;
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
            enable = false;
            side = "left";
            priority = 30;
            settings = { };
          };

          #
          # Center
          #

          "sway/window" = moduleOpt {
            enable = false;
            side = "center";
            priority = 10;
            settings = {
              max-length = 50;
            };
          };

          #
          # Right
          #

          "cpu" = moduleOpt {
            priority = 10;
            settings = {
              format = "${mkIcon ""} {load}";
            };
          };

          "memory" = moduleOpt {
            priority = 20;
            settings = {
              format = "${mkIcon ""} {used:.0f}G/{total:.0f}G";
            };
          };

          "disk#home" = moduleOpt {
            priority = 30;
            settings = {
              path = "/home";
              format = "${mkIcon ""} {free}";
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
              format = "{capacity}% ${mkIcon "{icon}"}";
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
  config =
    let
      cfg = config.traxys.waybar;

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
    lib.mkIf cfg.enable {
      traxys.waybar.modules-left = moduleListSide "left";
      traxys.waybar.modules-center = moduleListSide "center";
      traxys.waybar.modules-right = moduleListSide "right";

      programs.waybar = {
        enable = true;
        style = builtins.readFile ./waybar.css;
        settings = [
          (
            {
              layer = "top";
              position = "bottom";
              inherit (cfg) modules-left;
              inherit (cfg) modules-center;
              inherit (cfg) modules-right;
            }
            // (builtins.mapAttrs (_: v: v.settings) (lib.filterAttrs (_: v: v.enable) cfg.modules))
          )
        ];
      };
    };

}
