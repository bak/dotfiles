let g:mapleader = ","

" Download plug.vim if it doesn't exist yet
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source ~/.config/nvim/init.vim
\| endif

set clipboard+=unnamedplus " Always use the system clipboard

call plug#begin("~/.config/nvim/plugged")
Plug 'nvim-lua/plenary.nvim' " dependency of many plugins. Lua functions
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " parser, creates syntax tree, used for syntax highlighting, completion, and more
Plug 'neovim/nvim-lspconfig' " configs for the built-in LSP
Plug 'jeffkreeftmeijer/vim-dim' " Theme defined as terminal colors
Plug 'jeffkreeftmeijer/vim-numbertoggle' " autotoggle relative numbering when in normal mode
Plug 'nvim-telescope/telescope.nvim' " telescope UI for switching files, finding within files, etc
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " sorter for telescope
Plug 'hrsh7th/nvim-cmp' " completion
Plug 'onsails/lspkind.nvim' " for completion display
Plug 'ray-x/cmp-treesitter' " completion source
Plug 'hrsh7th/cmp-nvim-lsp' " completion source
Plug 'hrsh7th/cmp-buffer' " completion source
Plug 'sheerun/vim-polyglot' " multi-language support
Plug 'tpope/vim-vinegar' " netrw improved
Plug 'tpope/vim-fugitive' " provides :Git
Plug 'tpope/vim-rhubarb' " provides :GBrowse
Plug 'numToStr/Comment.nvim' " gc(c) comment mappings
Plug 'kylechui/nvim-surround' " add/delete/change surroundings
Plug 'tpope/vim-dispatch' " asynchronous :Make
Plug 'tpope/vim-rails', {'ft': ['ruby']} " Rails-specific, mostly for the navigation
Plug 'tpope/vim-repeat' " use . for Plugin map actions
Plug 'tpope/vim-endwise' " automatically close methods, blocks, loops. Uses vim-repeat
Plug 'tpope/vim-speeddating' " make <C-A> and <C-X> work on dates. Uses vim-repeat
Plug 'anuvyklack/middleclass' " OO system used in windows.nvim
Plug 'anuvyklack/windows.nvim' " autoflex/maximize/equalize split sizes
call plug#end()

colorscheme dim " Use Dim as the default color scheme
set number " Turn on line numbers
set completeopt=menu,menuone,noselect

lua <<EOF
  require('windows').setup()
  vim.keymap.set('n', '<C-w>z', '<Cmd>WindowsMaximize<CR>')
  vim.keymap.set('n', '<C-w>e', '<Cmd>WindowsEqualize<CR>')

  require('Comment').setup()

  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local lspkind = require('lspkind')

  cmp.setup({
    view = {
      entries = "native"
    },
    mapping = {
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items. I've set this to false because `do`, opening a ruby block, is autocompleted to describe in RSpec files.
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = "text",
        menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          treesitter = "[Treesitter]",
        })
      }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'treesitter' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- require'lspconfig'.tsserver.setup{}
  -- require'lspconfig'.ruby_ls.setup{}
EOF

" Configure Telescope
nnoremap <leader><leader> <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <leader>l <cmd>lua require('telescope.builtin').oldfiles()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>f <cmd>lua require('telescope.builtin').grep_string()<cr>

" Standard and vim-ruby disagree about indents, let standard win
let g:ruby_intent_assignment_style = 'variable'
