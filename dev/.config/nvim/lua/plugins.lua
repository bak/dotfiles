-- Install packer
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
	command = 'source <afile> | PackerCompile',
	group = packer_group,
	pattern = vim.fn.expand '$MYVIMRC',
})

return require('packer').startup(function(use)
	-- Meta
	use 'wbthomason/packer.nvim'

	-- Git
	use 'tpope/vim-fugitive'
	-- use 'tpope/vim-rhubarb'

	-- UI
	use 'jeffkreeftmeijer/vim-dim' -- Theme defined with terminal colors
	use 'jeffkreeftmeijer/vim-numbertoggle' -- switch to relative numbers in normal mode
	use 'nvim-lualine/lualine.nvim' -- Fancier statusline

	-- Working
	use 'kylechui/nvim-surround' -- add/delete/change surroundings
	use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
	use 'tpope/vim-dispatch'
	use 'tpope/vim-vinegar' -- netrw ergonomics
	use 'tpope/vim-sleuth' -- match tab/spaces of surrondings

	-- Completion
	use {
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"onsails/lspkind-nvim",
			"saadparwaiz1/cmp_luasnip",
			{
				"L3MON4D3/LuaSnip",
				requires = { "rafamadriz/friendly-snippets" },
			},
		},
	}

	-- Telescope
	use {
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-project.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
	}

	-- Treesitter
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/nvim-treesitter-textobjects", -- TS-driven textobject definitions
			"JoosepAlviste/nvim-ts-context-commentstring", -- smart about comment style when languages are embedded in other files
			"windwp/nvim-ts-autotag", -- uses TS to close HTML tags, why not
		},
	}

	-- LSP
	use "neovim/nvim-lspconfig"

	-- Automatically run PackerSync if bootstrapping
	if packer_bootstrap then
		require('packer').sync()
	end
end)

