-- Learn Vimscript the Hard Way: "A trick to learning something is to force yourself to use it." [in other words, remap, and unmap]
-- You can return to the previous file by using <c+o> (or <c+i>)

-- basic options
require("options")
require("keymappings")

-- packer and plugin installation and packages
require("packer-install")
require("packer-startup")

-- plugin configurations
require("plugins/nvim-tree-cfg")
require("plugins/keymappings")
require("plugins/options")
-- default cmp AND lsp (language server protocol) configuration (for python)
require("plugins/nvim-cmp-cfg")

-- autocmds (per file type)
require("autocmds")

require("luasnip-config")
require("luasnippets")
require("chat-gpt")

require("miniconda-python-loc")

-- Also see -> $HOME/.config/nvim/snippets/
require("luasnip.loaders.from_vscode").lazy_load({paths={"/home/"..USER.."/.config/nvim/snippets/"}})

vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/basic.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/datamuse.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/fasttext.vim ]], true)
