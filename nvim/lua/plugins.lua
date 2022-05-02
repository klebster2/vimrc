local execute = vim.api.nvim_command

local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
--git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packeradd packer.nvim'
end
local use = require('packer').use
require('packer').startup(function()
    -- Packer can manage itself as an optional plugin
    use 'wbthomason/packer.nvim'
    use 'morhetz/gruvbox'
    use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/vim-devicons' } }
    use { 'neovim/nvim-lspconfig', 'williamboman/nvim-lsp-installer' }
    use 'hrsh7th/nvim-compe'
    use 'hrsh7th/vim-vsnip'
    use 'nvim-lua/plenary.nvim'
    -- github
    use 'tpope/vim-fugitive'
    use 'jremmen/vim-ripgrep'
    use 'mbbill/undotree'
    -- nvim completion manager 2
    use 'ncm2/ncm2'
    use 'roxma/nvim-yarp'
    -- --use { 'klebster2/vim-for-poets', run = ':UpdateRemotePlugins' }
    -- use
end)

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
