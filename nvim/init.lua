-- Learn Vimscript the Hard Way: "A trick to learning something is to force yourself to use it." [in other words, remap, and unmap]
-- You can return to the previous file by using <c+o> (or <c+i>)

-- basic options
require("options")
require("keymappings")

-- packer installation and packer packages installation
require("packer-install")
require("packer-startup")

-- plugin configurations
require("plugins/nvim-tree-cfg")
-- Chat gpt for queries / completion
require("plugins/chat-gpt")
require("plugins/keymappings")
require("plugins/options")
-- customcompleters - datamuse
--require("customcompleters/datamuse")

-- default cmp AND lsp (language server protocol) configuration (for python)
require("luasnip-config")
require("luasnippets")
require("plugins/nvim-cmp-cfg")

-- autocmds (per file type)
require("autocmds")

-- miniconda for the nvim python loc
require("miniconda-python-loc")

vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/basic.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/datamuse.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/fasttext.vim ]], true)

vim.g.copilot_enabled = 0
