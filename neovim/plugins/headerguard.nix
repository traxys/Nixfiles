{ vim-headerguard }:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.plugins.headerguard = {
    enable = mkEnableOption "Enable headerguard";

    useCppComment = mkEnableOption "Use c++-style comments instead of c-style";
  };

  config =
    let
      cfg = config.plugins.headerguard;
    in
    mkIf cfg.enable {
      nixpkgs.overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins.extend (
            final': prev': {
              vim-headerguard = prev.vimUtils.buildVimPlugin {
                pname = "vim-headerguard";
                src = vim-headerguard;
                version = vim-headerguard.shortRev;
              };
            }
          );
        })
      ];

      extraPlugins = [ pkgs.vimPlugins.vim-headerguard ];

      globals.headerguard_use_cpp_comments = cfg.useCppComment;
    };
}
