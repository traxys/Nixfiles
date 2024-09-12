{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "diagram-nvim";
  originalName = "diagram.nvim";
  luaName = "diagram";
  defaultPackage = pkgs.vimPlugins.diagram-nvim;

  maintainers = [ lib.maintainers.traxys ];
}
