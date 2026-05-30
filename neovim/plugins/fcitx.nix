{ fcitx }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.plugins.fcitx = {
    enable = lib.mkEnableOption "Enable fctix.nvim";
  };

  config =
    let
      cfg = config.plugins.fcitx;
    in
    lib.mkIf cfg.enable {
      nixpkgs.overlays = [
        (final: prev: {
          vimPlugins = prev.vimPlugins.extend (
            final': prev': {
              fcitx = prev.vimUtils.buildVimPlugin {
                pname = "vim-headerguard";
                src = fcitx;
                version = fcitx.shortRev;
              };
            }
          );
        })
      ];

      extraPlugins = [ pkgs.vimPlugins.fcitx ];
      extraLuaPackages = ps: [ ps.ldbus ];

      extraConfigLua = ''
        require("fcitx").setup()
      '';
    };
}
