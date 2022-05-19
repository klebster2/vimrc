-- vim.lsp.set_log_level("debug")

require("options")
require("plugins")
require("keymappings")
require("autocmds")
require("nvim-compe-cfg")
require("nvim-tree-cfg")
require("lsp")
require("lsp.lua-ls")

vim.api.nvim_exec(
[[
colorscheme gruvbox
]],
true)
