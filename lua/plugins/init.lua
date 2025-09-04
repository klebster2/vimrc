return {
	{
		"christoomey/vim-tmux-navigator",
		lazy = true,
	},
	{ "wsdjeg/vim-lua" },
	{ "preservim/tagbar" },       -- view python objects
	{ "anuvyklack/windows.nvim" }, -- window resizer
	{ "numToStr/Comment.nvim" },
	{ "sheerun/vim-polyglot" },
	---{
	---	"zbirenbaum/copilot.lua",
	---	dependencies = {
	---		"hrsh7th/nvim-cmp",
	---	},
	---	cmd = "Copilot",
	---	event = "InsertEnter",
	---	lazy = true,
	---	config = function()
	---		require("copilot").setup()
	---	end,
	---},
	---{
	---	"zbirenbaum/copilot-cmp",
	---	after = { "copilot.lua" },
	---	config = function()
	---		require("copilot_cmp").setup()
	---	end,
	---},
	{
		"rshkarin/mason-nvim-lint",
		dependencies = {
			"mfussenegger/nvim-lint",
			"williamboman/mason.nvim",
		},
		setup = function()
			require("mason-nvim-lint").setup({
				ensure_installed = { "bacon", "flake8", "shellharden" },
			})
		end,
	},
	{
		"stsewd/isort.nvim",
		build = ":UpdateRemotePlugins", -- requires the python package isort
	},
}
