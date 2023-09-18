-- learn Vimscript the Hard Way: "A trick to learning something is to force yourself to use it." [in other words, remap, and unmap]
-- You can return to the previous file by using <c+o> (or <c+i>)
--- see :help 'runtimepath' or :help 'rtp'
require("conda-env")              --> $HOME/.vim_runtime/nvim/lua/conda-env.lua  -- Dependencies: (mini)-conda Get CONDA_EXE environment variable
-- Basic options
require("options")                --> $HOME/.vim_runtime/nvim/lua/options.lua
require("keymappings")            --> $HOME/.vim_runtime/nvim/lua/keymappings.lua
-- Packer installation and packer packages installation
require("packer-install")         --> $HOME/.vim_runtime/nvim/lua/packer-install.lua
require("packer-startup")         --> $HOME/.vim_runtime/nvim/lua/packer-startup.lua
-- Plugin configurations
require("plugins/nvim-tree-cfg")  --> $HOME/.vim_runtime/nvim/after/lua/nvim-tree-cfg.lua
require("plugins/keymappings")    --> $HOME/.vim_runtime/nvim/after/lua/plugins/keymappings.lua
require("plugins/options")        --> $HOME/.vim_runtime/nvim/after/lua/options.lua
-- Default CMP + LSP 'Mason' (language server protocol) configuration (for python)
require("luasnip-config")         --> $HOME/.vim_runtime/nvim/after/lua/luasnippets.lua
require("plugins/nvim-cmp-cfg")   --> $HOME/.vim_runtime/nvim/after/lua
-- Autocmds (per file type)
require("autocmds")               --> $HOME/.vim_runtime/nvim/lua/autocmds.lua
-- (legacy) vimscript files         --> $HOME/.vim_runtime/vimrcs/
vim.api.nvim_exec([[
  source $HOME/.vim_runtime/vimrcs/basic.vim 
  source $HOME/.vim_runtime/vimrcs/customcompleters/fasttext.vim 
  source $HOME/.vim_runtime/vimrcs/customcompleters/maskprediction.vim 
  source $HOME/.vim_runtime/vimrcs/customcompleters/code-generation.vim
]], true)
vim.g.copilot_enabled = 1
