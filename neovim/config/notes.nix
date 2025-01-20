{ helpers, pkgs, ... }:
{
  autoCmd = [
    {
      event = [ "User" ];
      pattern = [ "WikiBufferInitialized" ];
      callback = helpers.mkRaw ''
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
        callback = helpers.mkRaw ''
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
    backend = "ueberzug";

    integrations.markdown = {
      clearInInsertMode = true;
      enabled = true;
    };
  };

  plugins.diagram-nvim = {
    /* This does seem to work too well with the markdown preview */
    enable = false;

    settings = {
      renderer_options = {
        mermaid = {
          background = "transparent";
          theme = "dark";
        };
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    wiki-vim
    markdown-preview-nvim
    diagram-nvim
  ];
}
