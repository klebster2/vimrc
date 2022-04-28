vim.lsp.set_log_level("debug")

vim.api.nvim_exec(
[[
set runtimepath^=${HOME}/.vim_runtime runtimepath+=${HOME}/.vim_runtime/after runtimepath+=${HOME}/.vim
let &packpath=&runtimepath
source /home/kleber/.vim_runtime/vimrcs/customcomplete.vim
"source ${HOME}/.vimrc
]],
true)

require("keymappings")
require("options")
require("plugins")
require("nvim-compe-cfg")
require("nvim-tree-cfg")
require("lsp")
require("lsp.lua-ls")
