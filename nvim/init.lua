-- Learn Vimscript the Hard Way:
-- --> "A trick to learning something is to force yourself to use it [; meaning remap]"
-- basic options                  -- $HOME/.config/nvim/lua/
require("options")                -- $HOME/.config/nvim/lua/options.lua
require("keymappings")            -- $HOME/.config/nvim/lua/keymappings.lua
-- packer and plugin installation
require("packer-install")         -- $HOME/.config/nvim/lua/packer-install.lua
require("packer-startup")         -- $HOME/.config/nvim/lua/packer-startup.lua
-- plugin configurations          -- $HOME/.config/nvim/lua/plugins/ 
require("plugins.fzf-cfg")        -- $HOME/.config/nvim/lua/plugins/fzf-cfg.lua
require("plugins.nvim-compe-cfg") -- $HOME/.config/nvim/lua/plugins/nvim-compe-cfg.lua
require("plugins.nvim-tree-cfg")  -- $HOME/.config/nvim/lua/plugins/nvim-tree-cfg.lua
require("plugins.keymappings")    -- $HOME/.config/nvim/lua/plugins/keymappings.lua    -- keymappings for all plugins
require("plugins.options")        -- $HOME/.config/nvim/lua/plugins/keymappings.lua    -- keymappings for all plugins
vim.api.nvim_exec([[source $HOME/.vim_runtime/vimrcs/autocmds.vim]], true)
-- require("autocmds")               -- $HOME/.config/nvim/lua/autocmds.lua -- TODO
require("lsp")                    -- $HOME/.config/nvim/lua/lsp
require("lsp.lua-ls")             -- $HOME/.config/nvim/lua/lsp/lua-ls.lua
require("lsp.keymappings")        -- $HOME/.config/nvim/lua/lsp/keymappings.lua
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/basic.vim ]], true)
