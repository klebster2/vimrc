local conda_prefix = os.getenv('CONDA_PREFIX')
if conda_prefix then
  ---- Even if a conda env is active, set the python host program to the python of the neovim env
  local python_host_prog = string.gsub(conda_prefix, "/envs/.*","") .. "/envs/pynvim/bin/python"

  -- Check if all directories exist
  vim.g.python3_host_prog = python_host_prog
  vim.api.nvim_echo(
    {{"CONDA_PREFIX environment variable is set. Using python host program: " .. python_host_prog, "DebugMsg"}},
    true,
    {}
  )
else
  vim.api.nvim_echo(
    {{"CONDA_PREFIX environment variable is not set. Using default python host program.", "WarningMsg"}},
    true,
    {}
  )
end
