{ tree-sitter-vvk }:
{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    traxys.vvk = {
      enable = lib.mkEnableOption "vvk build-system";
    };
  };

  config =
    let
      cfg = config.traxys.vvk;
    in
    lib.mkIf cfg.enable {
      extraFiles."queries/vvk//highlights.scm".text = ''
        (comment) @comment

        [
             "["
             "]"
             "{"
             "}"
        ] @punctuation.bracket

        [
            "mod"
        ] @keyword.import

        (directive) @keyword.modifier

        (string_literal) @string

        (target
            name: (identifier) @function.call)

        (assign_statement
            name: (identifier) @variable)

        (argument
            name: (identifier) @variable.member)
      '';

      plugins.treesitter.grammarPackages = [
        (pkgs.tree-sitter.buildGrammar {
          language = "vvk";
          version = tree-sitter-vvk.rev;
          src = tree-sitter-vvk;
        })
      ];
    };
}
