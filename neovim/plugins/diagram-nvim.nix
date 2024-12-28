{
  lib,
  ...
}:
lib.nixvim.plugins.neovim.mkNeovimPlugin {
  name = "diagram-nvim";
  packPathName = "diagram.nvim";
  moduleName = "diagram";
  package = "diagram-nvim";

  maintainers = [ lib.maintainers.traxys ];
}
