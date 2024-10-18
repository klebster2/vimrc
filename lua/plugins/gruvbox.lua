return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = false,
			},
			strikethrough = true,
			invert_selection = false,
			invert_signs = false,
			invert_tabline = false,
			invert_intend_guides = false,
			contrast = "", -- can be "hard", "soft" or empty string
		})

		vim.cmd([[ colorscheme gruvbox ]])

		-- Make lua functions orange and bold
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "lua" },
			callback = function()
				vim.schedule(function()
					vim.api.nvim_set_hl(0, "Function", { fg = "#fe8019", bold = true })
				end)
			end,
		})
	end,
	setup = function()
		vim.api.nvim_set_hl(0, "MyPmenu", { bg = "#1d2021", fg = "#928374" })
		vim.api.nvim_set_hl(0, "MyNormal", { fg = "#98971a" })
		vim.api.nvim_set_hl(0, "MyFloatBorder", { fg = "#1d2021" })
		vim.api.nvim_set_hl(0, "MyPmenuSel", { bg = "#fbf1c7", fg = "#282828", bold = true, italic = true })
	end,
}
