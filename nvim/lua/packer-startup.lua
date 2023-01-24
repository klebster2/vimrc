local use = require('packer').use
require('packer').startup(function()
    -- Packer can manage itself as an optional plugin
    use 'wbthomason/packer.nvim' -- packer.nvim
    use 'morhetz/gruvbox' -- The gruvbox colorscheme
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons', -- optional, for file icons
      }, -- if using WSL2, Windows Terminal need nerd font so install Consolas NF on the OS terminal
      tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }  -- tree view
    use { 'ray-x/lsp_signature.nvim' }
    use { -- lsp configuration for linting, etc.
      'neovim/nvim-lspconfig',
      'williamboman/nvim-lsp-installer'
    }
    use { -- cmp for completion
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'onsails/lspkind-nvim',
    }
    use { -- luasnip - see $HOME/.vim_runtime/nvim/snippets
      'L3MON4D3/LuaSnip', -- snippets for completion
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    }
    use 'rafamadriz/friendly-snippets'
    use { -- cmp text editor-like plugins
      'uga-rosa/cmp-dictionary',
      'f3fora/cmp-spell', -- see $HOME/.vim_runtime/nvim/lua/plugins/nvim-cmp-cfg.lua
      'rudism/telescope-dict.nvim',
      'rhysd/vim-grammarous',
      'preservim/vim-wordy',
      -- 'vigoux/LanguageTool',
    }
    use 'svermeulen/vimpeccable'
    -- TODO configure tabnine
    -- use { 'tzachar/compe-tabnine', run='./install.sh', requires='hrsh7th/nvim-compe'}
    use 'nvim-lua/plenary.nvim'
    use 'tpope/vim-fugitive' -- github help
    use 'jremmen/vim-ripgrep' -- search
    use 'ibhagwan/fzf-lua' -- Quick file finding - updated for lua
    -- Undotree - make local undo history sane
    use { 'mbbill/undotree', run='vim -u NONE -c "helptags undotree/doc" -c q' }
    -- for lua development
    use 'wsdjeg/vim-lua'
    -- TODO: add ncm2? -- nvim completion manager 2 use 'ncm2/ncm2' -- use 'roxma/nvim-yarp'
    -- use { 'klebster2/vim-for-poets', run = ':UpdateRemotePlugins' }
    -- TODO - configure the below
    use { 'tpope/vim-surround', run='vim -u NONE -c "helptags surround/doc" -c q'}
    use { 'gelguy/wilder.nvim', config = function() end, }
    -- python stuffs
    use { 'psf/black', branch= 'main' } -- python black
    -- fix bug when user hasn't installed isort
    if vim.fn.executable('isort') == 1 then
      use 'fisadev/vim-isort' -- python
    end
    use { 'preservim/tagbar' } -- view python objects
    -- status bar
    use 'vim-airline/vim-airline'
    -- TODO fix
    -- use 'StefanRolink/vimify' -- spotify for vim
    use { "anuvyklack/windows.nvim", -- pretty window rescaling (nice to have)
      requires = {
          "anuvyklack/middleclass",
          "anuvyklack/animation.nvim"
      },
      config = function()
          vim.o.winwidth = 10
          vim.o.winminwidth = 10
          vim.o.equalalways = false
          require('windows').setup()
      end
    }
end)
