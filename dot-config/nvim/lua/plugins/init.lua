--[[
* Lua plugins
*
* Managed using packer.nvim
* https://github.com/wbthomason/packer.nvim
--]]

local packer = require('packer')

packer.startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Use plugins
	use 'neovim/nvim-lspconfig'
	use {
		'jose-elias-alvarez/null-ls.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
	}
	use "williamboman/mason.nvim"
end)

require("mason").setup()
