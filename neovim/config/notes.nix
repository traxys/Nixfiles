{ lib, pkgs, ... }:
{
  autoCmd = [
    {
      event = [ "User" ];
      pattern = [ "WikiBufferInitialized" ];
      callback = lib.nixvim.mkRaw ''
        function()
          vim.diagnostic.disable(0)
        end
      '';
    }
  ];

  files."after/ftplugin/markdown.lua" = {
    autoCmd = [
      {
        event = [ "InsertEnter" ];
        callback = lib.nixvim.mkRaw ''
          function()
            vim.cmd("Markview disable")
            -- vim.cmd("DiagramBuf disable")
          end
        '';
      }
    ];
  };

  globals = {
    wiki_global_load = 0;
    wiki_root = "~/wiki";
  };

  plugins.markview = {
    enable = true;

    lazyLoad.settings.ft = "markdown";
  };

  plugins.image = {
    enable = false;
    settings = {
      backend = "ueberzug";

      integrations.markdown = {
        clearInInsertMode = true;
        enabled = true;
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    wiki-vim
    markdown-preview-nvim
  ];
}
