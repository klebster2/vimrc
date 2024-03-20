local conda_exe = os.getenv('CONDA_EXE')
if conda_exe then
  local python_host_prog = conda_exe:match("(.*[/\\])"):sub(1, -2):match("(.*[/\\])"):sub(1, -2) .. "/envs/pynvim/bin/python"
  -- Check if all directories exist
  vim.g.python3_host_prog = python_host_prog
  print("CONDA_EXE environment variable is set. Using python host program: " .. python_host_prog)
else
  print("CONDA_EXE environment variable is not set. Please set it before running this script.")
end
