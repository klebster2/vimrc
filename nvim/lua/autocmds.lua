local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
--- first check vim is in the global scope

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"python"},
    callback = function()
      vim.schedule(function()
        keymap('n', "<localleader>pdb", "Iimport<space>pdb<return>pdb.set_trace()<esc>", opts)
        keymap('n', "<localleader>pl", "A # pylint: disable=true<esc>", opts)
        keymap('n', "<localleader>tt", "A # type: ignore<esc>", opts)
        keymap('n', "<localleader>c", "I#<esc>", opts)
        keymap('n', "<localleader>I", "<esc>:Isort", opts)
        vim.opt_local.foldenable = true
        vim.opt_local.foldmethod = "syntax"
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        local gen = require('gen')
        if gen then
          gen.prompts['Fix_Code'] = {
            prompt = "Rewrite the following python code. Use PEP 484 conventions, and type-hinting where necessary.\n\n```$filetype\n...\n```:\n```$filetype\n$text\n```",
            replace = true,
            extract = "```$filetype\n(.-)```"
          }
        end
      end)
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.py"},
    callback = function()
        local black = require('black')
        local isort = require('isort')
        if black and isort then
          vim.cmd("Isort")
          vim.cmd("Black")
        end
    end,
})

--- Bash / Shell scripts
vim.api.nvim_create_autocmd("FileType", {pattern = {"shell","bash"},
    callback = function()
      vim.schedule(function()
        keymap('n', "<localleader>b", "I#!/bin/bash<cr><esc>", opts)
        keymap('n', "<localleader>c", "I#<esc>", opts)
      end)
    end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = {"*.sh", "*.bash"},
    callback = function()
        vim.cmd("!shellcheck % 2>/dev/null | grep -Pv '^$'")
        -- check if is executable
        if vim.fn.executable(vim.fn.expand("%")) == 1 then
          vim.api.nvim_echo({{"Executable permissions are set for " .. vim.fn.expand("%"), "Type"}}, true, {})
        else
          vim.api.nvim_echo({{"Executable permissions are not set for " .. vim.fn.expand("%"), "Type"}}, true, {})
        end
    end,
})

--- Json
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

--- Autocommand to run Luacheck on save for Lua files
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = {"*.lua"},
    callback = function()
        vim.cmd("!luacheck % --no-color")
    end,
})

--- Autocommand to remove trailing whitespace for specified file types
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.sh", "*.awk", "*.bash", "*.js", "*.c", "*.cpp", "*.pl", "*.py", "*.lisp", "*.lua", "*.md"},
    callback = function()
        local current_view = vim.fn.winsaveview()
        vim.cmd("%s/\\s\\+$//e")
        vim.fn.winrestview(current_view)
    end,
})
