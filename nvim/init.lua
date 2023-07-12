-- learn Vimscript the Hard Way: "A trick to learning something is to force yourself to use it." [in other words, remap, and unmap]
-- You can return to the previous file by using <c+o> (or <c+i>)

-- -> Dependencies: (mini)-conda Get CONDA_EXE environment variable
local conda_exe = os.getenv('CONDA_EXE')
if conda_exe then
  local python_host_prog = conda_exe:match("(.*[/\\])"):sub(1, -2):match("(.*[/\\])"):sub(1, -2) .. "/envs/pynvim/bin/python3"
  -- Check if all directories exist
  vim.g.python3_host_prog = python_host_prog
else
  print("CONDA_EXE environment variable is not set. Please set it before running this script.")
end -- <- Dependencies: conda
-- Basic options
require("options")                --> $HOME/.vim_runtime/nvim/lua/options.lua
require("keymappings")            --> $HOME/.vim_runtime/nvim/lua/keymappings.lua
-- Packer installation and packer packages installation
require("packer-install")         --> $HOME/.vim_runtime/nvim/lua/packer-install.lua
require("packer-startup")         --> $HOME/.vim_runtime/nvim/lua/packer-startup.lua
-- Plugin configurations
require("plugins/nvim-tree-cfg")  --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-tree-cfg.lua
require("plugins/keymappings")    --> $HOME/.vim_runtime/nvim/lua/plugins/keymappings.lua
require("plugins/options")        --> $HOME/.vim_runtime/nvim/lua/plugins/options.lua
-- customcompleters - datamuse
--require("customcompleters/datamuse")
-- Default cmp AND lsp (language server protocol) configuration (for python)
require("luasnip-config")         --> $HOME/.vim_runtime/nvim/lua/luasnippets.lua
require("luasnippets")            --> $HOME/.vim_runtime/nvim/lua/luasnippets.lua
require("plugins/nvim-cmp-cfg")   --> $HOME/.vim_runtime/nvim/lua/plugins/nvim-cmp-cfg.lua
-- Autocmds (per file type)
require("autocmds")               --> $HOME/.vim_runtime/nvim/lua/autocmds.lua
-- (legacy) vimscript files         --> $HOME/.vim_runtime/vimrcs/
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/basic.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/fasttext.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/maskprediction.vim ]], true)
vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/code-generation.vim ]], true)
--vim.api.nvim_exec([[ source $HOME/.vim_runtime/vimrcs/customcompleters/openai-gpt.vim ]], true)
vim.g.copilot_enabled = 0
