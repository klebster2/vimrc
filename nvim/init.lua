---- learn Vimscript the Hard Way: "A trick to learning something is to force yourself to use it."
---- [in other words, remap, and unmap]

---- You can return to the previous file by using <c+o> (or <c+i>)

--- see :help 'runtimepath' or :help 'rtp'
--- Basic options
require("options")                   --> $HOME/.vim_runtime/nvim/lua/options.lua

--- Basic keymappings
require("keymappings")               --> $HOME/.vim_runtime/nvim/lua/keymappings.lua

--- Default CMP + LSP 'Mason' (language server protocol) configuration (for python)
require("packer-install")            --> $HOME/.vim_runtime/nvim/lua/packer-install.lua
                                        --> $HOME/.vim_runtime/nvim/lua/conda-env.lua
require("packer-startup")            --> $HOME/.vim_runtime/nvim/lua/packer-startup.lua

if require("packer") then
  require("plugins")               --> $HOME/.vim_runtime/nvim/lua/plugins/init.lua
end

require("thesaurus")                 --> $HOME/.vim_runtime/nvim/lua/thesaurus.lua
