local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.api.nvim_create_autocmd("FileType", {pattern = { "python" },
    callback = function()
        vim.schedule(function()
            keymap('n', "<localleader>pdb", "Iimport<space>pdb<return>pdb.set_trace()<esc>", opts)
            keymap('n', "<localleader>js", "Iimport<space>json<return><esc>", opts)
            keymap('n', "<localleader>os", "Iimport<space>os<return><esc>", opts)
            keymap('n', "<localleader>tq", "Iimport<space>tqdm<return><esc>", opts)
            keymap('n', "<localleader>ap", "Iimport<space>argparser<return><esc>", opts)
            keymap('n', "<localleader>main", "Iif __name__==\"__main__\":<return>pass<esc>", opts)
            keymap('n', "<localleader>doc", 'I"""<cr>Description<cr><cr>Parameters<cr>----------<cr><cr>Returns<cr>-------<cr><cr>See Also<cr>--------<cr><cr>Examples<cr>--------<cr>>>> <cr>"""<esc>/(<cr>Nvi(y/Param<cr>o<esc>p', opts)
--    """
--    Add up two integer numbers.
--
--    This function simply wraps the ``+`` operator, and does not
--    do anything interesting, except for illustrating what
--    the docstring of a very simple function looks like.
--
--    Parameters
--    ----------
--    num1 : int
--        First number to add.
--    num2 : int
--        Second number to add.
--
--    Returns
--    -------
--    int
--        The sum of ``num1`` and ``num2``.
--
--    See Also
--    --------
--    subtract : Subtract one integer from another.
--
--    Examples
--    --------
--    >>> add(2, 2)
--    4
--    >>> add(25, 0)
--    25
--    >>> add(10, -10)
--    0
            keymap('n', "<localleader>pl", "A # pylint: disable=", opts)
            keymap('n', "<localleader>c", "I#<esc>", opts)
            vim.opt_local.foldenable = true
            vim.opt_local.foldmethod = "syntax"
        end)
    end,
})

vim.api.nvim_create_autocmd("FileType", {pattern = { "shell", "bash"},
        callback = function()
            vim.schedule(function()
                keymap('n', "<localleader>b", "I#!/bin/bash<cr><esc>", opts)
                keymap('n', "<localleader>c", "I#<esc>", opts)
        end)
    end,
})

vim.api.nvim_create_autocmd("FileType", {pattern = { "json" },
        callback = function()
            vim.schedule(function()
                keymap('n', "<localleader>j", ":%!jq '.'<cr>", opts)
        end)
    end,
})

vim.api.nvim_create_autocmd("FileType", {pattern = { "lua" },
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
