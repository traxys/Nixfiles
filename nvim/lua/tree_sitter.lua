--[[ local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.rsh = {
	install_info = {
		url = "https://github.com/traxys/tree-sitter-rsh/", -- local path or git repo
		files = { "src/parser.c" },
	},
}
 ]]

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"rust",
		"c",
		"cpp",
		"json",
		"lua",
		"python",
		"toml",
		"latex",
		"nix",
		"vue",
		"javascript",
		"dart",
		--"rsh",
	},
	ident = {
		enable = true,
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "elixir", "teal" }, -- list of language that will be disabled
	},
	refactor = {
		highlight_definitions = { enable = true },
		highlight_current_scope = { enable = false },
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = "grr",
			},
		},
	},
})
