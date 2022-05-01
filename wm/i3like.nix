{
  config,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; {
  imports = [./i3.nix ./sway.nix];

  options = {
    wm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Manage window Manager";
      };
      kind = mkOption {
        type = types.enum ["i3" "sway"];
        default = "sway";
        description = "WM to use";
      };
      modifier = mkOption {
        type = types.str;
        description = "modifier key to use";
      };

      font = {
        name = mkOption {
          type = types.str;
          description = "Font to use";
        };
        style = mkOption {
          type = types.str;
          description = "Font style";
        };
        size = mkOption {
          type = types.float;
          description = "Font size";
        };
      };

      bar = {
        font = {
          name = mkOption {
            type = types.str;
            description = "Font to use for the bar";
          };
          style = mkOption {
            type = types.str;
            description = "Font style for the bar";
          };
          size = mkOption {
            type = types.float;
            description = "Font size for the bar";
          };
        };
      };

      printScreen = {
        enable = mkOption {
          type = types.bool;
          description = "Enable PrintScreen functionality";
          default = false;
        };
        keybind = mkOption {
          type = types.str;
          description = "PrintScreen key";
        };
        command = mkOption {
          type = types.str;
          description = "Print screen command";
        };
      };

      menu = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable menu";
        };
        keybind = mkOption {
          type = types.str;
          description = "Menu keybind";
        };
        command = mkOption {
          type = types.str;
          description = "Command to launch the menu";
        };
      };

      exit = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable exit keybind";
        };
        keybind = mkOption {
          type = types.str;
          description = "Menu keybind";
        };
        command = mkOption {
          type = types.str;
          description = "Command to exit the WM";
        };
      };

      notifications = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable notifications";
        };
        font = mkOption {
          type = types.str;
          description = "Font + Size";
        };
        defaultTimeout = mkOption {
          type = types.int;
          description = "Default timeout for notifications (in ms)";
        };
      };

      startup = mkOption {
        type = types.listOf (types.submodule {
          options = {
            command = mkOption {
              type = types.str;
              description = "Command that will be executed on startup.";
            };

            always = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to run command on each ${moduleName} restart.";
            };
          };
        });
      };

      wallpaper = mkOption {
        type = types.nullOr types.path;
        description = "wallpaper";
      };

      workspaces = {
        definitions = mkOption {
          type = types.attrsOf (types.submodule {
            options = {
              key = mkOption {
                type = types.str;
                description = "Keybind for the workspace";
              };
              output = mkOption {
                type = types.nullOr types.str;
                description = "Assign workspace to output";
                default = null;
              };
              assign = mkOption {
                type = types.listOf types.str;
                description = "Assign class elements";
                default = [];
              };
            };
          });
          description = "Workspace descriptions";
          default = {};
        };
        moveModifier = mkOption {
          type = types.str;
          description = "Modifier key to move windows to workspaces";
        };
      };

      keybindings = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        description = "keybindings";
      };
    };
  };
}
