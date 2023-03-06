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

require("nvim-tree").setup {
  view = {
    mappings = {
      list = {
        { key = "ga", action = "git_add", action_cb = git_add },
      }
    }
  }
}

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
      },
    },
  },
  renderer = {
    add_trailing = true,
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      symlink_arrow = " ➜ "
    }
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
