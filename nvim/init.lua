-- learn Vimscript the Hard Way: "A trick to learning something is to force yourself to use it." [in other words, remap, and unmap]
-- You can return to the previous file by using <c+o> (or <c+i>)

-- basic options
require("options")                --> $HOME/.vim_runtime/nvim/lua/options.lua
require("keymappings")            --> $HOME/.vim_runtime/nvim/lua/keymappings.lua

-- packer installation and packer packages installation
require("packer-install")         --> $HOME/.vim_runtime/nvim/lua/packer-install.lua
require("packer-startup")         --> $HOME/.vim_runtime/nvim/lua/packer-startup.lua

-- plugin configurations
require("plugins/nvim-tree-cfg")  --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-tree-cfg.lua

-- Chat gpt for queries / completion
-- require("plugins/chat-gpt")       --> $HOME/.vim_runtime/nvim/lua/plugins/chat-gpt.lua

require("plugins/keymappings")    --> $HOME/.vim_runtime/nvim/lua/plugins/keymappings.lua
require("plugins/options")        --> $HOME/.vim_runtime/nvim/lua/plugins/options.lua
-- customcompleters - datamuse
--require("customcompleters/datamuse")

-- default cmp AND lsp (language server protocol) configuration (for python)
require("luasnip-config")         --> $HOME/.vim_runtime/nvim/lua/luasnippets.lua
require("luasnippets")            --> $HOME/.vim_runtime/nvim/lua/luasnippets.lua
require("plugins/nvim-cmp-cfg")   --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-cmp-cfg.lua

-- autocmds (per file type)
require("autocmds")               --> $HOME/.vim_runtime/nvim/lua/autocmds.lua

-- miniconda for the nvim python loc
--require("miniconda-python-loc") --> $HOME/.vim_runtime/nvim/lua/miniconda-python-loc.lua

-- legacy vimscript files         --> $HOME/.vim_runtime/vimrcs/
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/basic.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/datamuse.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/fasttext.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/maskprediction.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/code-generation.vim ]], true)
--vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/openai-gpt.vim ]], true)

vim.g.copilot_enabled = 0
