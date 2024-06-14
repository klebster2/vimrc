local lib = require("nvim-tree.lib")

local gitignore_files = function(path, ignore_files)
  -- if exists .gitignore, read it and add to ignore_files
  local gitignore_exists = vim.fn.filereadable(path .. "/.gitignore") == 1
  if not gitignore_exists then
    return ignore_files
  end
  local gitignore = vim.fn.glob(path .. "/.gitignore")
  local lines = vim.fn.readfile(gitignore)
  local _ignore_files = ignore_files
  -- vim.cmd("echom 'gitignore: " .. gitignore .. "'")
  if gitignore == "" then
    return {}
  end
  for _, line in pairs(lines) do
    -- vim.cmd("echom 'gitignore line: " .. line .. "'")
    _ignore_files[#_ignore_files + 1] = line
    end
  return _ignore_files
end

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
end

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- copy default mappings here from defaults in next section
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  ---
  -- OR use all default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- remove a default
  vim.keymap.del('n', '<C-]>', { buffer = bufnr })

  -- override a default
  vim.keymap.set('n', '<C-e>', api.tree.reload,                       opts('Refresh'))

  -- add your mappings
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'ga',    git_add,                               opts('Git Add'))
end

require('nvim-tree').setup { -- BEGIN_DEFAULT_OPTS
  disable_netrw = true,
  hijack_netrw = true,
  update_cwd = true,
  view = {
    width = 35,
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
    custom = gitignore_files(vim.fn.getcwd(), {".git"}),
      -- Get all fuzzy paths from .gitignore (current directory)
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
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  on_attach = on_attach,
}
