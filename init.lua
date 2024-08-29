---- You can return to the previous file by using <c+o> (or <c+i>)
--- see :help 'runtimepath' or :help 'rtp'

--- Basic configuration that does not require plugins
require("basic")          --> $HOME/.config/nvim/lua/basic.lua --> [ $HOME/.config/nvim/lua/options.lua , $HOME/.config/nvim/lua/keymappings.lua , $HOME/.config/nvim/lua/autocmds.lua ]

--- Install Lazy
require("config.lazy")   --> $HOME/.config/nvim/lua/config/lazy.lua --> [ $HOME/.config/nvim/lua/conda-env.lua ]

-- Lazy loading of plugins
local lazy = require("lazy")
lazy.setup({
  spec = {
    { import = "plugins" },  --> $HOME/.config/nvim/lua/plugins/init.lua
  },                         --> $HOME/.config/nvim/lua/plugins/
})
