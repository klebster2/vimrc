local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.api.nvim_create_autocmd("FileType", {pattern = {"python"},
    callback = function()
      vim.schedule(function()
        keymap('n', "<localleader>pdb", "Iimport<space>pdb<return>pdb.set_trace()<esc>", opts)
        keymap('n', "<localleader>os", "Iimport<space>os<return><esc>", opts)
        keymap('n', "<localleader>pl", "A # pylint: disable=", opts)
        keymap('n', "<localleader>c", "I#<esc>", opts)
        keymap('n', "<localleader>I", "<esc>:Isort", opts)
        keymap('n', "<localleader>ff", "<esc>:Black<return><esc>:Isort<return>", opts)
        vim.opt_local.foldenable = true
        vim.opt_local.foldmethod = "syntax"
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
      end)
    end,
})

vim.api.nvim_create_autocmd("FileType", {pattern = {"shell","bash"},
    callback = function()
      vim.schedule(function()
        keymap('n', "<localleader>b", "I#!/bin/bash<cr><esc>", opts)
        keymap('n', "<localleader>c", "I#<esc>", opts)
      end)
    end,
})

vim.api.nvim_create_autocmd("FileType", {pattern = {"json"},
    callback = function()
      vim.schedule(function()
        keymap('n', "<localleader>j", ":%!jq '.'<cr>", opts)
      end)
    end,
})

vim.api.nvim_create_autocmd("FileType", {pattern = {"lua"},
    callback = function()
      vim.schedule(function()
        keymap('n', "<localleader>c", "I-- <esc>", opts)
        keymap('n', "<localleader>C", "O--[[<esc>jo--]]<esc>k0", opts)
        keymap('n', "<localleader>fu", "Ifunction()<cr>end<esc>ko", opts)
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
      end)
    end,
})
