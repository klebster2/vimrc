local vim = vim
--- first check vim is in the global scope

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.py"},
    callback = function()
        if vim.fn.executable("Black") == 0 then -- check if Black is not already installed
          vim.cmd("Black")
        end

        if vim.fn.executable("isort") == 0 then -- check if Isort is not already installed
          vim.cmd("Isort")
        end
    end,
})
vim.keymap.set("n", "<c-F>", require('fzf-lua').files, { desc = "Fzf Files" })
vim.keymap.set("n", "<c-T>", require('fzf-lua').helptags, { desc = "Fzf helptags" })
