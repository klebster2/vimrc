require("plugins/keymappings")        --> $HOME/.vim_runtime/nvim/lua/plugins/keymappings.lua
require("plugins/options")            --> $HOME/.vim_runtime/nvim/lua/plugins/options.lua
require("plugins/snippets")           --> $HOME/.vim_runtime/nvim/lua/plugins/snippets.lua
require("plugins/indent-blank-line")  --> $HOME/.vim_runtime/nvim/lua/plugins/indent-blank-line.lua
require("plugins/nvim-cmp-cfg")       --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-cmp-cfg.lua
require("plugins/nvim-comment")       --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-comment.lua
require("plugins/nvim-telescope")     --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-telescope.lua
require("plugins/nvim-tree-cfg")      --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-tree-cfg.lua
require("plugins/indent-blank-line")  --> $HOME/.vim_runtime/nvim/after/lua/plugins/indent-blank-line.lua
---require("plugins/treesitter-cfg")  --> $HOME/.vim_runtime/nvim/lua/plugins/treesitter-cfg.lua
require("luasnip-config")            --> $HOME/.vim_runtime/nvim/lua/luasnip-config.lua

---- TODO: split into autocmds-vendor and autocmds
--- Autocmds (per file type)
require("autocmds")                  --> $HOME/.vim_runtime/nvim/lua/autocmds.lua

