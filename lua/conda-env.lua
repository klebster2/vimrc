local vim = vim
local conda_prefix = os.getenv("CONDA_PREFIX")
if conda_prefix then
	---- Even if a conda env is active, set the python host program to the python of the neovim env
	local python_host_prog = string.gsub(conda_prefix, "/envs/.*", "") .. "/envs/pynvim/bin/python"

	-- Check if all directories exist
	vim.g.python3_host_prog = python_host_prog
end
