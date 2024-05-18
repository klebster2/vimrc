local execute = vim.api.nvim_command

local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

require("conda-env")                 --> $HOME/.vim_runtime/nvim/lua/conda-env.lua
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packeradd packer.nvim'
    -- Other dependencies: (mini)-conda Get CONDA_EXE environment variable
end
