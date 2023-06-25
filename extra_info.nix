{lib, ...}:
with lib;
with builtins; {
  options = {
    extraInfo.email = mkOption {
      type = types.str;
      description = "Email address";
    };

    extraInfo.username = mkOption {
      type = types.str;
      description = "Username to deploy the configuration as";
    };

    extraInfo.inputs = {
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
