local vim = vim
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
--- first check vim is in the global scope

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
