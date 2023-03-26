{config}:
with builtins; let
  cfg = config.wm;
  addKeyIf = cond: keybinds: newkey:
    if cond
    then newkey // keybinds
    else keybinds;

  keybindSolo = keys: submod:
    addKeyIf submod.enable keys {
      "${submod.keybind}" = "exec ${submod.command}";
    };
  keydefs = [cfg.printScreen cfg.menu cfg.exit];
  keybindingsKeydef = foldl' keybindSolo cfg.keybindings keydefs;

  mod = cfg.modifier;
  ws_def = cfg.workspaces.definitions;
  get_ws = ws: getAttr ws ws_def;
  workspaceFmt = name: let
    key = (get_ws name).key;
  in {
    "${mod}+${key}" = "workspace ${name}";
    "${mod}+${cfg.workspaces.moveModifier}+${key}" = "move container to workspace ${name}";
  };

  workspaceAssign = name: {
    workspace = name;
    output = (get_ws name).output;
  };

  classAssign = name: {
    "${name}" = map (app: {class = "${app}";}) ((get_ws name).assign);
  };
in {
  mkFont = mod: {
    names = [mod.name];
    style = mod.style;
    size = mod.size;
  };

  keybindings =
    (foldl' (x: y: x // y) {} (map workspaceFmt (attrNames ws_def)))
    // keybindingsKeydef;

  workspaceOutputAssign = map workspaceAssign (filter (ws: (get_ws ws).output != null) (attrNames ws_def));

  assigns = foldl' (x: y: x // y) {} (map classAssign (attrNames ws_def));
}
