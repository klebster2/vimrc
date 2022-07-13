local use = require('packer').use

require('packer').startup(function()
    -- Packer can manage itself as an optional plugin
    use 'wbthomason/packer.nvim'
    -- The gruvbox colorscheme
    use 'morhetz/gruvbox'
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        }, -- Windows terminal needs a nerd font so install Consolas NF on your terminal OS
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }    -- tree view
    -- lsp configuration for linting, etc.
    use { 'neovim/nvim-lspconfig', 'williamboman/nvim-lsp-installer' }
    --- nvim-compe for completion
    use 'hrsh7th/nvim-compe'
    use { 'tzachar/compe-tabnine', run='./install.sh', requires='hrsh7th/nvim-compe'}
    use 'hrsh7th/vim-vsnip'
    use 'nvim-lua/plenary.nvim'
    -- github
    use 'tpope/vim-fugitive'
    -- search
    use 'jremmen/vim-ripgrep'
    -- Quick file finding - updated for lua
    use 'ibhagwan/fzf-lua'
    -- make local undo history sane
    use { 'mbbill/undotree', run='vim -u NONE -c "helptags undotree/doc" -c q' }
    -- for lua development
    use 'wsdjeg/vim-lua'
    -- TODO: add ncm2
    -- nvim completion manager 2 use 'ncm2/ncm2'
    -- use 'roxma/nvim-yarp'
    -- use { 'klebster2/vim-for-poets', run = ':UpdateRemotePlugins' }
    -- use
    -- TODO - configure the below
    use { 'fgrsnau/ncm2-aspell' }
    use { 'gelguy/wilder.nvim', config = function() end, }
    -- python black
    use { 'psf/black', branch= 'main' }
    -- python import sort
    use 'fisadev/vim-isort'
    -- luavim statusline
    use 'beauwilliams/statusline.lua'
end)
