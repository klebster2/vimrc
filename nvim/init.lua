---- learn Vimscript the Hard Way: "A trick to learning something is to force yourself to use it."
---- [in other words, remap, and unmap]

---- You can return to the previous file by using <c+o> (or <c+i>)

--- see :help 'runtimepath' or :help 'rtp'
--- Basic options
require("options")                   --> $HOME/.vim_runtime/nvim/lua/options.lua
require("persistent-undo")           --> $HOME/.vim_runtime/nvim/lua/persistent-undo.lua

--- Basic keymappings
require("keymappings")               --> $HOME/.vim_runtime/nvim/lua/keymappings.lua

--- Default CMP + LSP 'Mason' (language server protocol) configuration (for python)
require("packer-install")            --> $HOME/.vim_runtime/nvim/lua/packer-install.lua
require("packer-startup")            --> $HOME/.vim_runtime/nvim/lua/packer-startup.lua
require("colorscheme")                  --> $HOME/.vim_runtime/nvim/lua/colorscheme.lua

if require("packer") then
  --- Vendor plugins ( --> $HOME/.vim_runtime/nvim/lua/packer-startup.lua )
  require("plugins.keymappings")        --> $HOME/.vim_runtime/nvim/lua/plugins/keymappings.lua (needs NvimTree, Telescope, Fugitive, Packer, ..)
  require("plugins.options")            --> $HOME/.vim_runtime/nvim/lua/plugins/options.lua
  require("plugins.snippets")           --> $HOME/.vim_runtime/nvim/lua/plugins/snippets.lua
  require("plugins.nvim-cmp-cfg")       --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-cmp-cfg.lua
  require("plugins.nvim-tree-cfg")      --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-tree-cfg.lua
  require("plugins.luasnip-config")     --> $HOME/.vim_runtime/nvim/lua/plugins/luasnip-config.lua
  require("autocmds")                   --> $HOME/.vim_runtime/nvim/lua/autocmds.lua  ---- TODO: split into autocmds-vendor and autocmds
end

require("thesaurus")                    --> $HOME/.vim_runtime/nvim/lua/thesaurus.lua
