-- Learn Vimscript the Hard Way:
--> "A trick to learning something is to <--
-->  force yourself to use it."          <--
--
--> [in other words, remap, and unmap]   <--

-- Note, you can jump to a file in neovim listed here using `gf` (for gump* file)
-- when the cursor hovers over a reference on the rhs (e.g. $HOME/.config/nvim/lua/ )
-- You can return to the previous file by using <c+o>

-- * Gump is kind of like the world 'jump' but it has more umph when pronounced this way

-- basic options                  -- $HOME/.config/nvim/lua/
require("options")                -- $HOME/.config/nvim/lua/options.lua
require("keymappings")            -- $HOME/.config/nvim/lua/keymappings.lua

-- packer and plugin installation
require("packer-install")         -- $HOME/.config/nvim/lua/packer-install.lua

-- packer packages
require("packer-startup")         -- $HOME/.config/nvim/lua/packer-startup.lua

-- plugin configurations          -- $HOME/.config/nvim/lua/plugins/ 
require("plugins.nvim-tree-cfg")  -- $HOME/.config/nvim/lua/plugins/nvim-tree-cfg.lua
require("plugins.keymappings")    -- $HOME/.config/nvim/lua/plugins/keymappings.lua    -- keymappings for all plugins
require("plugins.options")        -- $HOME/.config/nvim/lua/plugins/options.lua        -- plugin options

-- default cmp AND lsp (language server protocol) configuration
require("plugins.nvim-cmp-cfg")   -- $HOME/.config/nvim/lua/plugins/nvim-cmp-cfg.lua

-- autocmds (per file type)
require("autocmds")               -- $HOME/.config/nvim/lua/autocmds.lua

require("luasnip-config")         -- $HOME/.config/nvim/lua/luasnip-config.lua
require("luasnippets")            -- $HOME/.config/nvim/lua/luasnippets.lua

require("miniconda-python-loc")   -- $HOME/.config/nvim/lua/miniconda-python-loc.lua

-- Also see ->                    -- $HOME/.config/nvim/snippets/
--require("luasnip.loaders.from_vscode").lazy_load({paths={"/home/"..USER.."/.config/nvim/snippets/"}})

vim.api.nvim_exec([[
   source $HOME/.vim_runtime/vimrcs/basic.vim
   source $HOME/.vim_runtime/vimrcs/customcompleters/datamuse.vim
   source $HOME/.vim_runtime/vimrcs/customcompleters/fasttext.vim
]], true)
