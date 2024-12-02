vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
use 'wbthomason/packer.nvim'

use {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	requires = { {'nvim-lua/plenary.nvim'} }
}

use({
	'habamax/vim-habamax',
	as = 'habamax',
	config = function()
		vim.cmd('colorscheme habamax')
	end
})


use('mbbill/undotree')

use 'norcalli/nvim-colorizer.lua'

use 'williamboman/mason.nvim'
use 'williamboman/mason-lspconfig.nvim'

use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

-- Configuring LSP servers
use("neovim/nvim-lspconfig")

-- Autocompletion
use("hrsh7th/cmp-nvim-lsp")
use("hrsh7th/cmp-nvim")
use("hrsh7th/cmp-nvim-lua")
use({
  "glepnir/lspsaga.nvim",
  requires = {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-treesitter/nvim-treesitter" },
  },
})
use("onsails/lspkind.nvim")

end)
