{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.plugins.headerguard = {
    enable = mkEnableOption "Enable headerguard";

    useCppComment = mkEnableOption "Use c++-style comments instead of c-style";
  };

  config = let
    cfg = config.plugins.headerguard;
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [vim-headerguard];

      globals.headerguard_use_cpp_comments = cfg.useCppComment;
    };
}
