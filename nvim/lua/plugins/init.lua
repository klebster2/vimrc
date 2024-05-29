--- Colorscheme: gruvbox
--- Vendor plugins ( See $HOME/.vim_runtime/nvim/lua/packer-startup.lua )
require("plugins/keymappings")        --> $HOME/.vim_runtime/nvim/lua/plugins/keymappings.lua (needs NvimTree, Telescope, Fugitive, Packer, ..)
require("plugins/options")            --> $HOME/.vim_runtime/nvim/lua/plugins/options.lua
require("plugins/snippets")           --> $HOME/.vim_runtime/nvim/lua/plugins/snippets.lua
require("plugins/nvim-cmp-cfg")       --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-cmp-cfg.lua
require("plugins/nvim-comment")       --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-comment.lua
require("plugins/nvim-tree-cfg")      --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-tree-cfg.lua
require("luasnip-config")            --> $HOME/.vim_runtime/nvim/lua/luasnip-config.lua

---- TODO: split into autocmds-vendor and autocmds
---- Autocmds (per file type)
require("autocmds")                  --> $HOME/.vim_runtime/nvim/lua/autocmds.lua
