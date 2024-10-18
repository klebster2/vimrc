return {
	{
		"christoomey/vim-tmux-navigator",
		lazy = true,
	},
	{ "wsdjeg/vim-lua" },
	{ "gelguy/wilder.nvim" },
	{ "preservim/tagbar" }, -- view python objects
	{ "anuvyklack/windows.nvim" }, -- window resizer
	{ "numToStr/Comment.nvim" },
	{ "sheerun/vim-polyglot" },
	{
		"zbirenbaum/copilot.lua",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup()
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"tzachar/cmp-tabnine",
		build = "./install.sh",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		event = "InsertEnter",
		setup = function()
			require("cmp_tabnine.config"):setup({
				max_lines = 1000,
				max_num_results = 20,
				sort = true,
				run_on_every_keystroke = true,
				snippet_placeholder = "..",
				ignored_file_types = {},
				show_prediction_strength = false,
				min_percent = 0,
			})
		end,
	},
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
}
