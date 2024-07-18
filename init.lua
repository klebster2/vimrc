---- Learn Vimscript the Hard Way: "A trick to learning something is to force yourself to use it." [in other words, remap, and unmap]
---- You can return to the previous file by using <c+o> (or <c+i>)

--- see :help 'runtimepath' or :help 'rtp'

--- Basic options
require("options")                      --> $HOME/.config/nvim/lua/options.lua
require("persistent-undo")              --> $HOME/.config/nvim/lua/persistent-undo.lua

--- Basic keymappings
require("keymappings")                  --> $HOME/.config/nvim/lua/keymappings.lua

--- Default CMP + LSP 'Mason' (language server protocol) configuration (for python)
require("colorscheme")                  --> $HOME/.config/nvim/lua/colorscheme.lua

--- Packer startup ( bootstrap ) step (all plugins loaded here)
require("packer-startup")               --> $HOME/.config/nvim/lua/packer-startup.lua

require("autocmds")                     --> $HOME/.config/nvim/lua/autocmds.lua


-- Vendor plugins                    ( --> $HOME/.config/nvim/lua/packer-startup.lua )
if require("packer") then
  require("plugins.keymappings")        --> $HOME/.config/nvim/lua/plugins/keymappings.lua
  require("plugins.options")            --> $HOME/.config/nvim/lua/plugins/options.lua
  require("plugins.nvim-cmp-cfg")       --> $HOME/.config/nvim/lua/plugins/nvim-cmp-cfg.lua
  require("plugins.nvim-tree-cfg")      --> $HOME/.config/nvim/lua/plugins/nvim-tree-cfg.lua
  require("plugins.treesitter-cfg")     --> $HOME/.config/nvim/lua/plugins/treesitter-cfg.lua
  require("plugins.luasnip-config")     --> $HOME/.config/nvim/lua/plugins/luasnip-config.lua
  require("plugins.autocmds")           --> $HOME/.config/nvim/lua/plugins/autocmds.lua
end
