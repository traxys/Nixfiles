{ config, lib, pkgs, ... }:

with builtins;
with lib;
let
  cfg = config.wm;

  addKeyIf = cond: keybinds: newkey: if cond then newkey // keybinds else keybinds;
  keybindSolo = keys: submod: addKeyIf submod.enable keys {
    "${submod.keybind}" = "exec ${submod.command}";
  };
  keydefs = [ cfg.printScreen cfg.menu cfg.exit ];
  keybindingsKeydef = foldl' keybindSolo cfg.keybindings keydefs;

  mod = cfg.modifier;
  ws_def = cfg.workspaces.definitions;
  get_ws = ws: getAttr ws ws_def;
  workspaceFmt = name:
    let key = (get_ws name).key; in
    {
      "${mod}+${key}" = "workspace ${name}";
      "${mod}+${cfg.workspaces.moveModifier}+${key}" = "move container to workspace ${name}";
    };

  keybindings = (foldl' (x: y: x // y) { } (map workspaceFmt (attrNames ws_def)))
    // keybindingsKeydef;

  workspaceAssign = name:
    {
      workspace = name;
      output = (get_ws name).output;
    };

  workspaceOutputAssign = map workspaceAssign (filter (ws: (get_ws ws).output != null) (attrNames ws_def));

  classAssign = name: {
    "${name}" = map (app: { class = "${app}"; }) ((get_ws name).assign);
  };
  assigns = foldl' (x: y: x // y) { } (map classAssign (attrNames ws_def));

  startupNotifications =
    if cfg.notifications.enable then [{
      command = "${config.services.dunst.package}/bin/dunst";
      notification = false;
      always = true;
    }] else [ ];

  startup = startupNotifications ++ cfg.startup;
in
{
  config = mkIf (cfg.enable && cfg.kind == "i3") {
    programs = {
      i3status-rust = {
        enable = true;
        bars.bottom = {
          blocks = [
            {
              block = "disk_space";
              path = "/";
              info_type = "used";
              unit = "GB";
              alert = 90;
              warning = 80;
              format = ":{used}/{total}";
            }
            {
              block = "disk_space";
              path = "/home";
              info_type = "used";
              unit = "GB";
              alert = 90;
              warning = 80;
              format = ":{used}/{total}";
            }
            {
              block = "load";
              format = ":{1m}";
            }
            {
              block = "nvidia_gpu";
              label = "1050 Ti";
              show_memory = true;
              show_temperature = true;
            }
            {
              block = "sound";
              driver = "pulseaudio";
            }
            {
              block = "music";
              player = "spotify";
              format = "{combo}";
            }
            {
              block = "time";
            }
          ];
        };
      };
    };

    services.dunst = mkIf cfg.notifications.enable {
      enable = true;
      settings = {
        global = {
          timeout = "${toString cfg.notifications.defaultTimeout}ms";
          font = cfg.notifications.font;
        };
      };
    };

    wm.printScreen.command = mkDefault "${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
    wm.menu.command = mkDefault "${pkgs.rofi}/bin/rofi -modi drun#run#ssh -show drun";
    wm.exit.command = mkDefault "\"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'\"";

    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        config = let mkFont = mod: {
          names = [ mod.name ];
          style = mod.style;
          size = mod.size;
        }; in
          {
            inherit keybindings startup workspaceOutputAssign assigns;
            fonts = mkFont cfg.font;
            modifier = cfg.modifier;
            bars = [{
              fonts = mkFont cfg.bar.font;
              statusCommand = "${config.programs.i3status-rust.package}/bin/i3status-rs ${config.home.homeDirectory}/.config/i3status-rust/config-bottom.toml";
            }];
          };
      };
      scriptPath = ".hm-xsession";
    };

  };
}
