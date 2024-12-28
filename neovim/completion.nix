{ pkgs, ... }:
{
  extraPlugins = [ pkgs.vimPlugins.blink-compat ];

  plugins.blink-compat.enable = true;

  plugins.blink-cmp = {
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
      completion.list.selection = "manual";
      sources = {
        default = [
          "lsp"
          "buffer"
          "path"
          "git"
          "calc"
          "omni"
        ];
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
  };

  plugins.lsp.capabilities = # lua
    ''
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
    '';

  plugins.cmp-omni.enable = true;
  plugins.cmp-git.enable = true;
  plugins.cmp-calc.enable = true;
}
