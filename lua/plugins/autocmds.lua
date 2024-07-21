local vim = vim
--- first check vim is in the global scope

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.py"},
    callback = function()
        if vim.fn.executable("Black") == 0 then -- check if Black is not already installed
          vim.cmd("Black")
        end
    end,
})
