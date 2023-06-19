local lib = require("nvim-tree.lib")

local git_add = function()
  local node = lib.get_node_at_cursor()
  local gs = node.git_status.file

  -- If the file is untracked, unstaged or partially staged, we stage it
  if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
    vim.cmd("silent !git add " .. node.absolute_path)

  -- If the file is staged, we unstage
  elseif gs == "M " or gs == "A " then
    vim.cmd("silent !git restore --staged " .. node.absolute_path)
  end

  lib.refresh_tree()
end

require('nvim-tree').setup { -- BEGIN_DEFAULT_OPTS
  disable_netrw = true,
  hijack_netrw = true,
  ignore_buffer_on_setup = false,
  update_cwd = true,
  view = {
    width = 35,
    mappings = {
      custom_only = false,
      list = {
        { key = "ga", action = "git_add", action_cb = git_add },
      },
    },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  renderer = {
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
  },
  filters = {
    custom = { "~/.fzf-git" },
    exclude = { ".git" },
  },
  actions = {
    open_file = {
      resize_window = false,
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
}
local function open_nvim_tree(data)

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
