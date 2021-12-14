plugins = [
    "aklt/plantuml-syntax",
    "kyazdani42/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
    "nvim-lua/lsp-status.nvim",
    "kosayoda/nvim-lightbulb",
    "Yggdroot/indentLine",
    "lewis6991/gitsigns.nvim",
    "nvim-lua/plenary.nvim",
    "bluz71/vim-moonfly-colors",
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-path",
    "kdheepak/cmp-latex-symbols",
    "hrsh7th/nvim-cmp",
    "dpelle/vim-Grammalecte",
    "dpelle/vim-LanguageTool",
    "nvim-lua/lsp_extensions.nvim",
    "ray-x/lsp_signature.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/popup.nvim",
    "NTBBloodbath/galaxyline.nvim",
    "drmikehenry/vim-headerguard",
    "andymass/vim-matchup",
    "b3nj5m1n/kommentary",
    "onsails/lspkind-nvim",
    "editorconfig/editorconfig-vim",
    "jose-elias-alvarez/null-ls.nvim",
    "nathom/filetype.nvim",
    "tweekmonster/startuptime.vim",
]

inputs = ""
nvim_plugins = "nvim-plugins = [\n";
for plugin in plugins:
    repo,plugin = plugin.split('/')
    inputs += f'"{plugin}" = {{\n'
    inputs += f'  url = "github:{repo}/{plugin}";\n'
    inputs += f'  flake = false;\n'
    inputs += "};\n"

    nvim_plugins += "  {\n"
    nvim_plugins += f'    name = "{plugin}";\n'
    nvim_plugins += f'    path = inputs."{plugin}";\n'
    nvim_plugins += "  }\n"
nvim_plugins += "];\n"

with open("flake.nix.in") as f:
    flake = f.read()
    flake = flake.replace("@inputs@\n", inputs)
    flake = flake.replace("@plugins@\n", nvim_plugins)
    out = open("flake.nix", "w")
    out.write(flake)

