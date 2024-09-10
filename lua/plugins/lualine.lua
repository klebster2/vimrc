-- Define a function to check that ollama is installed and working
local function get_condition()
    return package.loaded["ollama"] and require("ollama").status ~= nil
end


-- Define a function to check the status and return the corresponding icon
local function get_status_icon()
  local status = require("ollama").status()

  if status == "IDLE" then
    return "OLLAMA IDLE"
  elseif status == "WORKING" then
    return "OLLAMA BUSY"
  end
end

return { 'nvim-lualine/lualine.nvim',
  --event = "VeryLazy",
--  optional = true,
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        fmt = string.lower,
        theme  = require('lualine.themes.gruvbox_dark'),
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { "mode"},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype', get_status_icon, get_condition},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    }
  end,
}
