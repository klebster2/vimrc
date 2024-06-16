vim.cmd([[ colorscheme retrobox ]])
vim.api.nvim_set_hl(0, "MyPmenu", { bg = "#1d2021", fg = "#928374" })
vim.api.nvim_set_hl(0, "MyNormal", { fg = "#98971a" })
vim.api.nvim_set_hl(0, "MyFloatBorder", { fg = "#1d2021" })
vim.api.nvim_set_hl(0, "MyPmenuSel", { bg = "#fbf1c7", fg = "#282828", bold = true, italic = true })
vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#d5c4a1" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#fbf1c7" })
vim.api.nvim_set_hl(0, "CmpItemAbbrFuzzy", { fg = "#ec5300" })
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#8ec07c" })
--vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#282828" })
-- Make lua functions orange and bold
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"lua"},
    callback = function()
      vim.schedule(function()
        vim.api.nvim_set_hl(0, "Function", { fg = "#fe8019", bold = true })
    end)
  end,
})


vim.api.nvim_set_hl(0, "CmpItemMenuCopilot", { fg = "#8ec07c" })
--vim.api.nvim_set_hl(0, "CmpItemAbbrMatchCopilot", { fg = "#fbf1c7" })
--vim.api.nvim_set_hl(0, "CmpItemAbbrFuzzyCopilot", { fg = "#ec5300" })
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#8ec07c"})
