{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    commands = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Extra commands to be created";
    };
  };

  config.extraConfigVim = let
    commands = cmds:
      concatStringsSep "\n" (map (cmd: "command ${cmd} ${getAttr cmd cmds}") (attrNames cmds));
  in
    commands config.commands;
}
