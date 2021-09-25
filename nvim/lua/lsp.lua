vim.lsp.set_log_level("debug")

local lsp_status = require('lsp-status')
lsp_status.register_progress()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

require('lspkind').init({})
local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
local util = require 'lspconfig/util'

if not lspconfig.rsh_lsp then
	configs.rsh_lsp = {
    	default_config = {
      		cmd = {'rsh-lsp'},
      		filetypes = {'rsh'},
			root_dir = util.path.dirname,
      		settings = {},
    	};
  	}
end

lspconfig.rust_analyzer.setup{
	on_attach=lsp_status.on_attach,
	settings = {
		["rust-analyzer"] = {
			procMacro = { 
				enable = true 
			},
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true
			},
			updates = {
				channel = "nightly"
			},
		}
	},
	capabilities = capabilities
}
lspconfig.jsonls.setup{
	on_attach=lsp_status.on_attach,
	cmd = { "json-languageserver", "--stdio" },
	capabilities = capabilities
}
lspconfig.bashls.setup{
	on_attach=lsp_status.on_attach,
	capabilities = capabilities
}
lspconfig.rsh_lsp.setup{
	on_attach=lsp_status.on_attach,
	capabilities = capabilities
}
lspconfig.clangd.setup{
	on_attach = lsp_status.on_attach,
	handlers = lsp_status.extensions.clangd.setup(),
	init_options = { clangdFileStatus = true},
	capabilities = capabilities
}
lspconfig.texlab.setup{
	on_attach = lsp_status.on_attach,
	capabilities = capabilities
}

lspconfig.rnix.setup{
	on_attach = lsp_status.on_attach,
	capabilities = capabilities
}

lspconfig.dartls.setup{
	on_attach = lsp_status.on_attach,
	capabilities = capabilities,
	cmd = {"dart", vim.fn.expand("$DART_SDK") .. "/snapshots/analysis_server.dart.snapshot", "--lsp"}
}

lspconfig.vuels.setup{
	on_attach = lsp_status.on_attach,
	capabilities = capabilities,
	config = {
		vetur = {
			defaultFormatter = {
				js = "prettier",
				ts = "prettier",
				html = "prettier"
			}
		}
	}
}
