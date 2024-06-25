--- Colorscheme: gruvbox
--- Vendor plugins ( See $HOME/.config/nvim/nvim/lua/packer-startup.lua )
require("plugins/keymappings")        --> $HOME/.config/nvim/nvim/lua/plugins/keymappings.lua (needs NvimTree, Telescope, Fugitive, Packer, ..)
require("plugins/options")            --> $HOME/.config/nvim/nvim/lua/plugins/options.lua
require("plugins/snippets")           --> $HOME/.config/nvim/nvim/lua/plugins/snippets.lua
require("plugins/nvim-comment")       --> $HOME/.config/nvim/nvim/lua/plugins/nvim-comment.lua
require("plugins/nvim-cmp-cfg")       --> $HOME/.config/nvim/nvim/lua/plugins/nvim-cmp-cfg.lua
require("plugins/nvim-tree-cfg")      --> $HOME/.config/nvim/nvim/lua/plugins/nvim-tree-cfg.lua
require("luasnip-config")            --> $HOME/.config/nvim/nvim/lua/luasnip-config.lua

---- TODO: split into autocmds-vendor and autocmds
---- Autocmds (per file type)
require("autocmds")                  --> $HOME/.config/nvim/nvim/lua/autocmds.lua
