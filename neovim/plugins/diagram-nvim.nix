{
  lib,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "diagram-nvim";
  originalName = "diagram.nvim";
  luaName = "diagram";
  package = "diagram-nvim";

  maintainers = [ lib.maintainers.traxys ];
}
