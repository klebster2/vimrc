-- Basic configuration (does not require plugins):
require("basic")          --> $HOME/.config/nvim/lua/basic.lua --> [ $HOME/.config/nvim/lua/options.lua , $HOME/.config/nvim/lua/keymappings.lua , $HOME/.config/nvim/lua/autocmds.lua ]

-- Install Lazy for plugin management
--- @type function
local lazy_setup = require("config.lazy")   --> $HOME/.config/nvim/lua/config/lazy.lua --> [ $HOME/.config/nvim/lua/conda-env.lua ]

-- Load plugins with Lazy
---@type table
local lazy_spec = {
  spec = {
    { import = "plugins" }, --> $HOME/.config/nvim/lua/plugins/init.lua
  },                        --> $HOME/.config/nvim/lua/plugins/
}
---@type boolean
local status, _ = pcall(lazy_setup, lazy_spec)
if not status then
  print("Failed to lazy load plugins!")
end

