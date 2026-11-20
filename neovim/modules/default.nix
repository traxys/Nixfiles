{ tree-sitter-vvk }: { lib, ... }: {
  imports = [
    ./commands.nix
    (lib.modules.importApply ./vvk.nix { inherit tree-sitter-vvk; })
  ];
}
