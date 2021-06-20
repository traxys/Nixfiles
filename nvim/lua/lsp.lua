vim.lsp.set_log_level("debug")

local lsp_status = require('lsp-status')
lsp_status.register_progress()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

require('lspkind').init({})

require'lspconfig'.rust_analyzer.setup{
	on_attach=lsp_status.on_attach,
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true
			},
			updates = {
				channel = "nightly"
			},
		}
	},
	capabilities = capabilities
}

require'lspconfig'.jsonls.setup{
	on_attach=lsp_status.on_attach,
	cmd = { "json-languageserver", "--stdio" },
	capabilities = capabilities
}
require'lspconfig'.bashls.setup{
	on_attach=lsp_status.on_attach,
	capabilities = capabilities
}
require'lspconfig'.clangd.setup{
	on_attach = lsp_status.on_attach,
	handlers = lsp_status.extensions.clangd.setup(),
	init_options = { clangdFileStatus = true},
	capabilities = capabilities
}
require'lspconfig'.texlab.setup{
	on_attach = lsp_status.on_attach,
	capabilities = capabilities
}

require'lspconfig'.rnix.setup{
	on_attach = lsp_status.on_attach,
	capabilities = capabilities
}

--[[ local system_name
if vim.fn.has("mac") == 1 then
	system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
	system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
	system_name = "Windows"
else
	print("Unsupported system for sumneko")
end

local sumneko_root_path = "/home/traxys/softs/lua-language-server"
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

require'lspconfig'.sumneko_lua.setup {
	on_attach=lsp_status.on_attach,
	capabilities = capabilities,
	cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				-- Setup your lua path
				path = vim.split(package.path, ';'),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {'vim'},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand('$VIMRUNTIME/lua')] = true,
					[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
				},
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
} ]]
