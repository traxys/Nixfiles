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
        command = "Markview disable";
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

  extraPlugins = with pkgs.vimPlugins; [
    wiki-vim
    markdown-preview-nvim
  ];
}
