-- Setup LSP non LSP provided files using null-ls plugin.
-- TODO: Toggle LSP diagnostics and code actions as they are noisy.
-- TODO: Setup formatters and code completions.

local shell_ft = {
	filetypes = {
		"sh", "bash"
	}
}

local docs_ft = {
	filetypes = {
		"markdown", "text"
	}
}

local null_ls = require "null-ls"
-- LSP for shell scripting.
local shellcheck_diagnostics =
		null_ls.builtins.diagnostics.shellcheck.with(shell_ft)
local shellcheck_code_actions =
		null_ls.builtins.code_actions.shellcheck.with(shell_ft)
local zsh_diagnostics = null_ls.builtins.diagnostics.zsh
-- LSP for documentation.
local markdownlint_diagnostics =
		null_ls.builtins.diagnostics.markdownlint
local write_good_diagnostics =
		null_ls.builtins.diagnostics.write_good.with(docs_ft)
-- LSP for web filetypes.
local curlylint_diagnostics = null_ls.builtins.diagnostics.curlylint
local tidy_diagnostics = null_ls.builtins.diagnostics.tidy
-- LSP for configuration filetypes.
local jq_formatting = null_ls.builtins.formatting.jq
-- Miscellaneous
local todo_comments = null_ls.builtins.diagnostics.todo_comments
local trail_space = null_ls.builtins.diagnostics.trail_space

null_ls.setup ({
	debug = false,
	sources = {
		shellcheck_diagnostics,
		shellcheck_code_actions,
		zsh_diagnostics,
		markdownlint_diagnostics,
		write_good_diagnostics,
		curlylint_diagnostics,
		tidy_diagnostics,
		jq_formatting,
		todo_comments,
		trail_space,
	}
})

-- Setup LSP for programming languages
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>l', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setqflist, opts)

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap=true, silent=true }
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>ic', vim.lsp.buf.incoming_calls, bufopts)
	vim.keymap.set('n', '<space>oc', vim.lsp.buf.outgoing_calls, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

-- TODO: Add LSP for javascript, babeljs and typescript.
local servers = {
	"clangd",
	"pyright",
	"gopls",
	"rust_analyzer",
}

for _, lsp in pairs(servers) do
	require('lspconfig')[lsp].setup {
		on_attach = on_attach,
	}
end

-- Configure UI
local _border = "single"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover,
	{ border = _border }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
	vim.lsp.handlers.signature_help,
	{ border = _border }
)

vim.diagnostic.config{
	float = { border = _border }
}

require('lspconfig.ui.windows').default_options = {
	border = _border
}
