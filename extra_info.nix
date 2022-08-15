{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options = {
    extraInfo.email = mkOption {
      type = types.nullOr types.str;
      description = "Email address";
      default = null;
    };

    extraInfo.inputs = {
      keyboard = mkOption {
        type = types.listOf types.str;
        description = "Sway keyboard identifier";
        default = [];
      };
      touchpad = mkOption {
        type = types.nullOr types.str;
        description = "Sway touchpad identifier";
        default = null;
      };
    };

    extraInfo.outputs = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      description = "Description of the outputs";
      default = {};
    };
  };
}
