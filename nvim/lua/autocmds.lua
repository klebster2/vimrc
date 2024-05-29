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
        if vim.fn.executable("Black") == 0 then -- check if Isort is not installed
          vim.cmd("Black")
        end

        if vim.fn.executable("isort") == 0 then -- check if Isort is not installed
          vim.cmd("Isort")
        end
    end,
})

vim.api.nvim_exec([[
  augroup textFileSpell
    autocmd!
    autocmd FileType markdown,text,rst,tex,bib,adoc setlocal spell
    autocmd BufRead,BufNewFile *.md,*.txt,*.rst,*.tex,*.latex,*.bib,*.adoc,*.asciidoc setlocal spell
  augroup END
]], false)

local bufIsBig = function(bufnr)
	local max_filesize = 100 * 1024 -- 100 KB
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
	if ok and stats and stats.size > max_filesize then
		return true
	else
		return false
	end
end
local cmp = require('cmp')
local default_cmp_sources = cmp.config.sources({
	{ name = 'nvim_lsp' },
	{ name = 'nvim_lsp_signature_help' },
}, {
	{ name = 'vsnip' },
	{ name = 'path' }
})
-- If a file is too large, I don't want to add to it's cmp sources treesitter, see:
-- https://github.com/hrsh7th/nvim-cmp/issues/1522
vim.api.nvim_create_autocmd('BufReadPre', {
	callback = function(t)
		local sources = default_cmp_sources
		if not bufIsBig(t.buf) then
			sources[#sources+1] = {name = 'treesitter', group_index = 2}
		end
	cmp.setup.buffer {
		sources = sources
	}
	end
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
