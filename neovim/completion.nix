{ pkgs, ... }:
{
  extraPlugins = [ pkgs.vimPlugins.blink-compat ];

  plugins.blink-cmp = {
    luaConfig.pre = # lua
      ''
        require('blink.compat').setup({debug = true})
      '';

    enable = true;
    settings = {
      keymap = {
        preset = "enter";
        "<A-Tab>" = [
          "snippet_forward"
          "fallback"
        ];
        "<A-S-Tab>" = [
          "snippet_backward"
          "fallback"
        ];
        "<Tab>" = [
          "select_next"
          "fallback"
        ];
        "<S-Tab>" = [
          "select_prev"
          "fallback"
        ];
      };
      completion.enabled_providers = [
        "lsp"
        "buffer"
        "path"
        "git"
        "calc"
        "omni"
      ];
      # Does not seem to work
      providers = {
        git = {
          name = "git";
          module = "blink.compat.source";
        };
        calc = {
          name = "calc";
          module = "blink.compat.source";
        };
        omni = {
          name = "omni";
          module = "blink.compat.source";
        };
      };
    };
  };

  plugins.lsp.capabilities = # lua
    ''
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
    '';

  plugins.cmp-omni.enable = true;
  plugins.cmp-git.enable = true;
  plugins.cmp-calc.enable = true;

  performance.combinePlugins.standalonePlugins = [ "nvim-cmp" ];
}
