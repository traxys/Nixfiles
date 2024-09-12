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
            vim.cmd("DiagramBuf disable")
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
  };

  plugins.image = {
    enable = true;
    backend = "ueberzug";

    integrations.markdown = {
      clearInInsertMode = true;
      enabled = true;
    };
  };

  plugins.diagram-nvim = {
    enable = true;

    settings = {
      renderer_options = {
        mermaid = {
          background = "transparent";
          theme = "dark";
        };
      };
    };
  };

  extraPackages = with pkgs; [
    mermaid-cli
    d2
    plantuml
  ];

  extraPlugins = with pkgs.vimPlugins; [
    wiki-vim
    markdown-preview-nvim
    diagram-nvim
  ];
}
