local result = vim.api.nvim_exec(
[[
set runtimepath^=${HOME}/.vim_runtime runtimepath+=${HOME}/.vim_runtime/after runtimepath+=${HOME}/.vim
let &packpath=&runtimepath
"source ${HOME}/.vimrc
source ${HOME}/.vim_runtime/vimrcs/customcomplete.vim
]],
true)

require("keymappings")
require("options")
require("plugins")
require("nvim-compe-cfg")
require("nvim-tree-cfg")
require("lsp")
require("lsp.lua-ls")
