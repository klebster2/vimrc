-- Learn Vimscript the Hard Way:
-- --> "A trick to learning something is to force yourself to use it [; meaning remap]"
-- basic options                  -- ./nvim/lua/
require("options")                -- ./nvim/lua/options.lua
require("keymappings")            -- ./nvim/lua/keymappings.lua
-- packer and plugin installation
require("packer-install")         -- ./nvim/lua/packer-install.lua
require("packer-startup")         -- ./nvim/lua/packer-startup.lua
-- plugin configurations          -- ./nvim/lua/plugins/ 
require("plugins.fzf-cfg")        -- ./nvim/lua/plugins/fzf-cfg.lua
require("plugins.nvim-compe-cfg") -- ./nvim/lua/plugins/nvim-compe-cfg.lua
require("plugins.nvim-tree-cfg")  -- ./nvim/lua/plugins/nvim-tree-cfg.lua
require("plugins.keymappings")    -- ./nvim/lua/plugins/keymappings.lua    -- keymappings for all plugins
require("plugins.options")        -- ./nvim/lua/plugins/keymappings.lua    -- keymappings for all plugins
vim.api.nvim_exec([[source $HOME/.vim_runtime/vimrcs/autocmds.vim]], true)
-- require("autocmds")               -- ./nvim/lua/autocmds.lua -- TODO
require("lsp")                    -- ./nvim/lua/lsp
require("lsp.lua-ls")             -- ./nvim/lua/lsp/lua-ls.lua
require("lsp.keymappings")        -- ./nvim/lua/lsp/keymappings.lua
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/basic.vim ]], true)
