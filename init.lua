---- You can return to the previous file by using <c+o> (or <c+i>)
--- see :help 'runtimepath' or :help 'rtp'

--- Basic options
require("options")                      --> $HOME/.config/nvim/lua/options.lua

--- Basic keymappings
require("keymappings")                  --> $HOME/.config/nvim/lua/keymappings.lua

--- Default CMP + LSP 'Mason' (language server protocol) configuration (for python)
require("colorscheme")                  --> $HOME/.config/nvim/lua/colorscheme.lua
require("autocmds")                     --> $HOME/.config/nvim/lua/autocmds.lua

-- Install Lazy
require("config.lazy")   --> $HOME/.config/nvim/lua/config/lazy.lua
-- Lazy loading of plugins
require("lazy").setup({
  spec = {
    { import = "plugins" },  --> $HOME/.config/nvim/lua/plugins/init.lua
  },                         --> $HOME/.config/nvim/lua/plugins/
})
